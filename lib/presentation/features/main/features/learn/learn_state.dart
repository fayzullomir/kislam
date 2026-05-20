part of 'learn_cubit.dart';

/// Top-level tab on the Learn screen — questions list vs. terms list.
enum LearnTab { questions, terms }

@freezed
class LearnState with _$LearnState {
  const LearnState._();

  const factory LearnState({
    @Default(LearnTab.questions) LearnTab tab,
    @Default('all') String selectedCategoryId,
    @Default('') String searchQuery,
    @Default(TermCategory.all) TermCategory termCategory,
  }) = _LearnState;
}

@freezed
class LearnEvent with _$LearnEvent {
  const factory LearnEvent() = _LearnEvent;
}
