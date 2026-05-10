part of 'learn_cubit.dart';

@freezed
class LearnState with _$LearnState {
  const LearnState._();

  const factory LearnState({
    @Default('all') String selectedCategoryId,
    @Default('') String searchQuery,
  }) = _LearnState;
}

@freezed
class LearnEvent with _$LearnEvent {
  const factory LearnEvent() = _LearnEvent;
}
