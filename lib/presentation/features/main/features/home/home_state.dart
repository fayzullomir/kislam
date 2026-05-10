part of 'home_cubit.dart';

@freezed
class HomeState with _$HomeState {
  const HomeState._();

  @freezed
  const factory HomeState({
//
    @Default("") String firstName,
    @Default("") String lastName,
    @Default("") String profilePhotoUrl,
    @Default("") String phoneNumber,
//
    @Default([]) List<BannerImage> banners,
    @Default(LoadingState.loading) LoadingState bannersState,
//
    /// Prayer times computed for `DateTime.now()` and the next day. Both
    /// are null when no GPS coordinates are saved (manual-only setup).
    DailyPrayerTimes? todayPrayers,
    DailyPrayerTimes? tomorrowPrayers,

    /// Next-prayer hero values. Re-derived every second from
    /// [todayPrayers] / [tomorrowPrayers] by the home-cubit ticker.
    PrayerName? nextPrayerName,
    DateTime? nextPrayerTime,
    Duration? countdown,

    /// Human-readable city/country label shown on the hero card. Falls
    /// back to an empty string when no location is saved.
    @Default('') String locationLabel,
//
  }) = _HomeState;

  String get fullName => '$firstName $lastName'.trim();
}

@freezed
class HomeEvent with _$HomeEvent {
  const factory HomeEvent() = _HomeEvent;
}
