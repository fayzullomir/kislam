part of 'district_selection_cubit.dart';

@freezed
class DistrictSelectionState with _$DistrictSelectionState {
  const factory DistrictSelectionState({
    //
    @Default([]) List<District> districts,
    @Default(LoadingState.loading) LoadingState districtsState,
    //
    @Default(-1) int selectedRegionId,
    District? selectedDistrict,
    //
  }) = _DistrictSelectionState;
}

@freezed
class DistrictSelectionEvent with _$DistrictSelectionEvent {
  const factory DistrictSelectionEvent() = _DistrictSelectionEvent;
}
