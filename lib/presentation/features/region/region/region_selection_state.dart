part of 'region_selection_cubit.dart';

@freezed
class RegionSelectionState with _$RegionSelectionState {
  const factory RegionSelectionState({
    //
    @Default([]) List<Region> regions,
    @Default(LoadingState.loading) LoadingState regionsState,
    //
    @Default(-1) int selectedCountryId,
    Region? selectedRegion,
    //
  }) = _RegionSelectionState;
}

@freezed
class RegionSelectionEvent with _$RegionSelectionEvent {
  const factory RegionSelectionEvent() = _RegionSelectionEvent;
}
