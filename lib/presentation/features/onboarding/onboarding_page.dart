import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:koreaislam/core/gen/localization/strings.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/islamic_design_tokens.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/noor_tokens.dart';
import 'package:koreaislam/presentation/router/app_router.dart';
import 'package:koreaislam/presentation/support/cubit/base_page.dart';

import 'onboarding_cubit.dart';

/// Two-step Noor onboarding:
///   1. Welcome — نور logo + greeting
///   2. "At your own pace" — gentle pacing reassurance
///
/// Madhab and location are picked on dedicated pages right after this flow.
@RoutePage()
class OnboardingPage extends BasePage<OnboardingCubit, OnboardingState, OnboardingEvent> {
  OnboardingPage({super.key});

  final PageController _pageController = PageController();

  @override
  void onEventEmitted(BuildContext context, OnboardingEvent event) {}

  @override
  Widget onWidgetBuild(BuildContext context, OnboardingState state) {
    final isFirst = state.currentPageIndex == 0;
    final isLast = state.isLastPageShown;

    return Scaffold(
      backgroundColor: context.noor.neutral,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (i) => cubit(context).setPageIndex(i),
                    children: const [
                      _StepWelcome(),
                      _StepNoRush(),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: _BottomActions(
                    isFirst: isFirst,
                    isLast: isLast,
                    onBack: () => _goBack(),
                    onContinue: () => _goNext(context, isLast),
                  ),
                ),
              ],
            ),
            // Skip — only on the first step.
            if (isFirst)
              Positioned(
                top: 8,
                right: 12,
                child: TextButton(
                  onPressed: () => _finish(context),
                  child: Text(
                    Strings.onboardingSkip,
                    style: context.noor.tBody.copyWith(
                      color: context.noor.inkSoft,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _goBack() {
    _pageController.previousPage(
      duration: IslamicDesignTokens.durBase,
      curve: IslamicDesignTokens.easeNoor,
    );
  }

  void _goNext(BuildContext context, bool isLast) {
    if (isLast) {
      _finish(context);
      return;
    }
    _pageController.nextPage(
      duration: IslamicDesignTokens.durBase,
      curve: IslamicDesignTokens.easeNoor,
    );
  }

  void _finish(BuildContext context) {
    // Permissions come right after onboarding so the location permission
    // is already granted by the time the user reaches the location picker.
    context.router.replace(PermissionsRoute());
  }
}

// ===========================================================================
// Step 1 — Welcome
// ===========================================================================

class _StepWelcome extends StatelessWidget {
  const _StepWelcome();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 80),
          Text(
            'نور',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: IslamicDesignTokens.fontArabic,
              color: context.noor.primary,
              fontSize: 96,
              height: 1,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            Strings.onboardingWelcomeEyebrow,
            textAlign: TextAlign.center,
            style: context.noor.tEyebrow,
          ),
          const SizedBox(height: 24),
          Text(
            Strings.onboardingWelcomeTitle,
            textAlign: TextAlign.center,
            style: context.noor.tDisplay,
          ),
          const SizedBox(height: 16),
          Text(
            Strings.onboardingWelcomeBody,
            textAlign: TextAlign.center,
            style: context.noor.tBody.copyWith(
              color: context.noor.inkMuted,
            ),
          ),
        ],
      ),
    );
  }
}

// ===========================================================================
// Step 2 — At your own pace
// ===========================================================================

class _StepNoRush extends StatelessWidget {
  const _StepNoRush();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 100),
          // Decorative curve — green solid + gold dashed.
          SizedBox(
            width: 180,
            height: 80,
            child: CustomPaint(
              painter: _CurvePainter(
                green: context.noor.primary,
                gold: context.noor.secondary,
              ),
            ),
          ),
          const SizedBox(height: 28),
          Text(
            Strings.onboardingNoRushEyebrow,
            textAlign: TextAlign.center,
            style: context.noor.tEyebrow,
          ),
          const SizedBox(height: 6),
          Text(
            Strings.onboardingNoRushTitle,
            textAlign: TextAlign.center,
            style: context.noor.tDisplay,
          ),
          const SizedBox(height: 16),
          Text(
            Strings.onboardingNoRushBody,
            textAlign: TextAlign.center,
            style: context.noor.tBody.copyWith(
              color: context.noor.inkMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _CurvePainter extends CustomPainter {
  final Color green;
  final Color gold;

  _CurvePainter({required this.green, required this.gold});

  @override
  void paint(Canvas canvas, Size size) {
    final greenPaint = Paint()
      ..color = green
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Smooth curve — left low, peak, valley, right high.
    final path = Path()
      ..moveTo(0, size.height * 0.85)
      ..cubicTo(
        size.width * 0.25, size.height * 0.0,
        size.width * 0.55, size.height * 0.95,
        size.width, size.height * 0.1,
      );
    canvas.drawPath(path, greenPaint);

    // Endpoint dots.
    final dotPaint = Paint()..color = green;
    canvas.drawCircle(Offset(0, size.height * 0.85), 5, dotPaint);
    canvas.drawCircle(Offset(size.width, size.height * 0.1), 5, dotPaint);

    // Gold dashed parallel line (slightly below).
    final goldPaint = Paint()
      ..color = gold
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final dashed = Path()
      ..moveTo(0, size.height * 0.95)
      ..cubicTo(
        size.width * 0.3, size.height * 0.5,
        size.width * 0.7, size.height * 0.85,
        size.width, size.height * 0.65,
      );
    _drawDashedPath(canvas, dashed, goldPaint, dashLen: 8, gapLen: 6);
  }

  void _drawDashedPath(
    Canvas canvas,
    Path path,
    Paint paint, {
    required double dashLen,
    required double gapLen,
  }) {
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = (distance + dashLen).clamp(0, metric.length).toDouble();
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance = next + gapLen;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _CurvePainter oldDelegate) =>
      oldDelegate.green != green || oldDelegate.gold != gold;
}

// ===========================================================================
// Bottom action bar — single Continue on step 1, Back/Begin on step 2.
// ===========================================================================

class _BottomActions extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final VoidCallback onBack;
  final VoidCallback onContinue;

  const _BottomActions({
    required this.isFirst,
    required this.isLast,
    required this.onBack,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    if (isFirst) {
      return _PrimaryButton(label: Strings.onboardingContinue, onTap: onContinue);
    }
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: _OutlineButton(label: Strings.onboardingBack, onTap: onBack),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: _PrimaryButton(
            label: isLast ? Strings.onboardingBegin : Strings.onboardingContinue,
            onTap: onContinue,
          ),
        ),
      ],
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _PrimaryButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.noor.primary,
      borderRadius: BorderRadius.circular(IslamicDesignTokens.radiusBtn),
      child: InkWell(
        borderRadius: BorderRadius.circular(IslamicDesignTokens.radiusBtn),
        onTap: onTap,
        child: Container(
          height: 56,
          alignment: Alignment.center,
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: IslamicDesignTokens.fontDisplay,
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _OutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _OutlineButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.noor.surface,
      borderRadius: BorderRadius.circular(IslamicDesignTokens.radiusBtn),
      child: InkWell(
        borderRadius: BorderRadius.circular(IslamicDesignTokens.radiusBtn),
        onTap: onTap,
        child: Container(
          height: 56,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(IslamicDesignTokens.radiusBtn),
            border: Border.all(color: context.noor.line, width: 1),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: IslamicDesignTokens.fontDisplay,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: context.noor.ink,
            ),
          ),
        ),
      ),
    );
  }
}
