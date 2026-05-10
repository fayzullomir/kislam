part of 'onboarding_cubit.dart';

@freezed
class OnboardingState with _$OnboardingState {
  const OnboardingState._();

  const factory OnboardingState({
    @Default(0) int currentPageIndex,
  }) = _OnboardingState;

  /// 2-step Noor onboarding flow (welcome + no-rush).
  /// Settings (madhab, location) live on dedicated pages after this flow.
  static const int totalSteps = 2;

  bool get isLastPageShown => currentPageIndex == totalSteps - 1;
}

@freezed
class OnboardingEvent with _$OnboardingEvent {
  const factory OnboardingEvent() = _OnboardingEvent;
}
