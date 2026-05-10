import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:koreaislam/core/enum/enums.dart';
import 'package:koreaislam/core/handler/future_handler.dart';
import 'package:koreaislam/core/handler/stream_handler.dart';
import 'package:koreaislam/core/handler/stream_subscriptions.dart';
import 'package:koreaislam/data/datasource/preference/calculation_method_preferences.dart';
import 'package:koreaislam/data/datasource/preference/location_preferences.dart';
import 'package:koreaislam/data/datasource/preference/madhab_preferences.dart';
import 'package:koreaislam/data/repositories/ad/ad_repository.dart';
import 'package:koreaislam/data/repositories/banner/banner_repository.dart';
import 'package:koreaislam/data/repositories/prayer_times/prayer_times_repository.dart';
import 'package:koreaislam/data/repositories/profile/profile_repository.dart';
import 'package:koreaislam/domain/models/ad/partner_ad/partner_ads.dart';
import 'package:koreaislam/domain/models/banner/banner_image.dart';
import 'package:koreaislam/domain/models/location/user_location.dart';
import 'package:koreaislam/domain/models/prayer/daily_prayer_times.dart';
import 'package:koreaislam/domain/models/prayer/prayer_name.dart';
import 'package:koreaislam/presentation/support/cubit/base_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

part 'home_cubit.freezed.dart';
part 'home_state.dart';

@injectable
class HomeCubit extends BaseCubit<HomeState, HomeEvent> {
  final AdRepository _adRepository;
  final BannerRepository _bannerRepository;
  final ProfileRepository _profileRepository;
  final PrayerTimesRepository _prayerTimesRepository;
  final LocationPreferences _locationPreferences;
  final MadhabPreferences _madhabPreferences;
  final CalculationMethodPreferences _calculationMethodPreferences;

  HomeCubit(
    this._adRepository,
    this._bannerRepository,
    this._profileRepository,
    this._prayerTimesRepository,
    this._locationPreferences,
    this._madhabPreferences,
    this._calculationMethodPreferences,
  ) : super(HomeState()) {
    _readSavedUser();
    _watchSavedProfile();

    _refreshPrayerTimes();
    _watchPrayerInputs();
    _startCountdownTicker();

    loadData();
  }

  final _subscriptions = StreamSubscriptions();
  Timer? _countdownTimer;

  @override
  Future<void> close() {
    _subscriptions.cancelAll();
    _countdownTimer?.cancel();
    _locationPreferences.notifier.removeListener(_refreshPrayerTimes);
    _madhabPreferences.notifier.removeListener(_refreshPrayerTimes);
    _calculationMethodPreferences.notifier.removeListener(_refreshPrayerTimes);
    return super.close();
  }

  void loadData() {
    fetchBanners();
    fetchPartnerAds();
  }

  void reloadData() {
    _readSavedUser();
    _refreshPrayerTimes();
    fetchBanners();
    fetchPartnerAds();
  }

  // -------------------------------------------------------------------------
  // Prayer-time pipeline
  // -------------------------------------------------------------------------

  /// Recompute today's & tomorrow's prayer times from the current
  /// preferences. Called once on init plus whenever the user changes
  /// their location, madhab, or calculation method.
  void _refreshPrayerTimes() {
    final today = _prayerTimesRepository.computeForToday();
    final tomorrow = _prayerTimesRepository
        .computeForDate(DateTime.now().add(const Duration(days: 1)));

    updateState((s) => s.copyWith(
          todayPrayers: today,
          tomorrowPrayers: tomorrow,
          locationLabel: _resolveLocationLabel(_locationPreferences.location),
        ));
    _tickCountdown();
  }

  /// Subscribes to every preference that affects prayer-time calculation
  /// so the home screen re-renders the moment the user changes any of
  /// them via Profile.
  void _watchPrayerInputs() {
    _locationPreferences.notifier.addListener(_refreshPrayerTimes);
    _madhabPreferences.notifier.addListener(_refreshPrayerTimes);
    _calculationMethodPreferences.notifier.addListener(_refreshPrayerTimes);
  }

  /// 1-second ticker that drives the hero card countdown. The tick is
  /// cheap — it only re-derives `(name, time, remaining)` from the
  /// already-cached `DailyPrayerTimes`.
  void _startCountdownTicker() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _tickCountdown(),
    );
  }

  void _tickCountdown() {
    final today = states.todayPrayers;
    if (today == null) {
      updateState((s) => s.copyWith(
            nextPrayerName: null,
            nextPrayerTime: null,
            countdown: null,
          ));
      return;
    }

    final now = DateTime.now();
    // When today's Isha has passed, [DailyPrayerTimes.nextPrayer] returns
    // tomorrow's Fajr (from `fajrAfter`). If we already have a freshly
    // computed `tomorrowPrayers`, prefer that so all subsequent home
    // refreshes line up against the same dataset.
    var next = today.nextPrayer(now);
    if (next.name == PrayerName.fajr && next.time.isBefore(today.fajr)) {
      // We're past Isha — roll over to tomorrow's prayers if available.
      final tomorrow = states.tomorrowPrayers;
      if (tomorrow != null) {
        next = (name: PrayerName.fajr, time: tomorrow.fajr);
      }
    }

    final remaining = next.time.difference(now);
    if (remaining.isNegative) {
      // Edge case: the second between expiry and the next recompute —
      // recompute eagerly so the user never sees a negative timer.
      _refreshPrayerTimes();
      return;
    }

    updateState((s) => s.copyWith(
          nextPrayerName: next.name,
          nextPrayerTime: next.time,
          countdown: remaining,
        ));
  }

  String _resolveLocationLabel(UserLocation location) {
    if (location.city?.isNotEmpty == true) return location.city!;
    if (location.country?.isNotEmpty == true) return location.country!;
    return '';
  }

  // -------------------------------------------------------------------------
  // Profile + ads (existing)
  // -------------------------------------------------------------------------

  void _readSavedUser() {
    updateState((state) => state.copyWith(
          firstName: _profileRepository.userFirstName,
          lastName: _profileRepository.userLastName,
          phoneNumber: _profileRepository.userPhoneNumber,
          profilePhotoUrl: _profileRepository.profilePhotoUrl,
        ));
  }

  void _watchSavedProfile() {
    _subscriptions.add(
      _profileRepository.firstNameStream
          .initStream()
          .onData((d) => updateState((s) => s.copyWith(firstName: d)))
          .execute(),
    );

    _subscriptions.add(
      _profileRepository.lastNameStream
          .initStream()
          .onData((d) => updateState((s) => s.copyWith(lastName: d)))
          .execute(),
    );

    _subscriptions.add(
      _profileRepository.phoneNumberStream
          .initStream()
          .onData((d) => updateState((s) => s.copyWith(phoneNumber: d)))
          .execute(),
    );

    _subscriptions.add(
      _profileRepository.profilePhotoStream
          .initStream()
          .onData((d) => updateState((s) => s.copyWith(profilePhotoUrl: d)))
          .execute(),
    );
  }

  void fetchBanners() {
    _bannerRepository
        .fetchBanners()
        .initFuture()
        .onStart(() {
          updateState((state) => state.copyWith(
                bannersState: LoadingState.loading,
              ));
        })
        .onSuccess((banners) {
          updateState((state) => state.copyWith(
                banners: banners,
                bannersState:
                    banners.isEmpty ? LoadingState.empty : LoadingState.success,
              ));
        })
        .onError((error) {
          updateState((state) => state.copyWith(
                bannersState: LoadingState.error,
              ));
        })
        .onFinished(() {})
        .executeFuture();
  }

  void fetchPartnerAds() {
    _adRepository
        .fetchPartnerAds()
        .initFuture()
        .onStart(() {
          updateState((state) => state.copyWith(
                partnerAdsState: LoadingState.loading,
              ));
        })
        .onSuccess((ads) {
          updateState((state) => state.copyWith(
                partnerAds: ads,
                partnerAdsState:
                    ads.isEmpty ? LoadingState.empty : LoadingState.success,
              ));
        })
        .onError((error) {
          updateState((state) => state.copyWith(
                partnerAdsState: LoadingState.error,
              ));
        })
        .onFinished(() {})
        .executeFuture();
  }

  openUrlInCustomTab(String url, String title) async {
    try {
      var uri = Uri.parse(url);
      await launchUrl(uri);
    } catch (e) {
      stateMessageManager.showErrorSnackBar(
        e.toString(),
        "Urlni parse qilishda xatolik yuz berdi",
      );
    }
  }
}
