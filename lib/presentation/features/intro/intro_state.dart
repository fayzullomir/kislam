part of 'intro_cubit.dart';

@freezed
class IntroState with _$IntroState {
  const IntroState._();

  const factory IntroState({
    @Default(0) int currentPageIndex,
  }) = _IntroState;

  /// 3-step Noor onboarding flow.
  static const int totalSteps = 3;

  bool get isLastPageShown => currentPageIndex == totalSteps - 1;
}

@freezed
class IntroEvent with _$IntroEvent {
  const factory IntroEvent(IntroEventType type) = _IntroEvent;
}

enum IntroEventType { _ }
