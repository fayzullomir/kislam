part of 'learn_cubit.dart';

@freezed
class LearnState with _$LearnState {
  const LearnState._();

  @freezed
  const factory LearnState({
    //
    @Default(LoadingState.loading) LoadingState guideCategoriesState,
    @Default([]) List<GuideCategory> guideCategories,
    //
  }) = _LearnState;
}

@freezed
class LearnEvent with _$LearnEvent {
  const factory LearnEvent() = _LearnEvent;
}
