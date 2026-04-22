part of 'intro_cubit.dart';

@freezed
class IntroState with _$IntroState {
  const IntroState._();

  const factory IntroState({
    @Default(0) int currentPageIndex,
  }) = _IntroState;

  List<IntroPageData> get introPages => [
        IntroPageData(
          image: Assets.images.intro.stepFirst,
          title: Strings.introStepFirstTitle,
          message: Strings.introStepFirstMessage,
        ),
        IntroPageData(
          image: Assets.images.intro.stepSecond,
          title: Strings.introStepSecondTitle,
          message: Strings.introStepSecondMessage,
        ),
        IntroPageData(
          image: Assets.images.intro.stepThird,
          title: Strings.introStepThirdTitle,
          message: Strings.introStepThirdMessage,
        ),
      ];

  bool get isLastPageShown => currentPageIndex == introPages.length - 1;
}

@freezed
class IntroEvent with _$IntroEvent {
  const factory IntroEvent(IntroEventType type) = _IntroEvent;
}

enum IntroEventType { _ }
