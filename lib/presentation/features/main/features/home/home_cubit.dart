import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:koreaislam/core/enum/enums.dart';
import 'package:koreaislam/core/handler/future_handler.dart';
import 'package:koreaislam/core/handler/stream_handler.dart';
import 'package:koreaislam/core/handler/stream_subscriptions.dart';
import 'package:koreaislam/data/repositories/ad/ad_repository.dart';
import 'package:koreaislam/data/repositories/banner/banner_repository.dart';
import 'package:koreaislam/data/repositories/profile/profile_repository.dart';
import 'package:koreaislam/domain/models/ad/partner_ad/partner_ads.dart';
import 'package:koreaislam/domain/models/banner/banner_image.dart';
import 'package:koreaislam/presentation/support/cubit/base_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

part 'home_cubit.freezed.dart';
part 'home_state.dart';

@injectable
class HomeCubit extends BaseCubit<HomeState, HomeEvent> {
  final AdRepository _adRepository;
  final BannerRepository _bannerRepository;
  final ProfileRepository _profileRepository;

  HomeCubit(
    this._adRepository,
    this._bannerRepository,
    this._profileRepository,
  ) : super(HomeState()) {
    _readSavedUser();
    _watchSavedProfile();

    loadData();
  }

  final _subscriptions = StreamSubscriptions();

  @override
  Future<void> close() {
    _subscriptions.cancelAll();
    return super.close();
  }

  void loadData() {
    fetchBanners();
    fetchPartnerAds();
  }

  void reloadData() {
    _readSavedUser();
    fetchBanners();
    fetchPartnerAds();
  }

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
