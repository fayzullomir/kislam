part of 'gender_selection_cubit.dart';

@freezed
class GenderSelectionState with _$GenderSelectionState {
  const factory GenderSelectionState({
    //
    Gender? selectedGender,
    //
  }) = _GenderSelectionState;
}

@freezed
class GenderSelectionEvent with _$GenderSelectionEvent {
  const factory GenderSelectionEvent() = _GenderSelectionEvent;
}
