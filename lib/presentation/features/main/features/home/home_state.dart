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
    @Default([]) List<PartnerAd> partnerAds,
    @Default(LoadingState.loading) LoadingState partnerAdsState,
//
  }) = _HomeState;

  String get fullName => '$firstName $lastName'.trim();
}

@freezed
class HomeEvent with _$HomeEvent {
  const factory HomeEvent() = _HomeEvent;
}
