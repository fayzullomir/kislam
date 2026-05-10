import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:koreaislam/core/gen/localization/strings.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/islamic_design_tokens.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/noor_tokens.dart';
import 'package:koreaislam/presentation/router/app_router.dart';
import 'package:koreaislam/presentation/support/cubit/base_page.dart';

import 'intro_cubit.dart';

/// Three-step Noor onboarding:
///   1. Welcome — نور logo + greeting
///   2. "At your own pace" — gentle pacing reassurance
///   3. "Last step" — quick settings (location / madhab / language)
@RoutePage()
class IntroPage extends BasePage<IntroCubit, IntroState, IntroEvent> {
  IntroPage({super.key});

  final PageController _pageController = PageController();

  @override
  void onEventEmitted(BuildContext context, IntroEvent event) {}

  @override
  Widget onWidgetBuild(BuildContext context, IntroState state) {
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
                      _StepLastSettings(),
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
                    Strings.introSkip,
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
    context.router.replaceAll([PermissionsRoute()]);
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
            Strings.introWelcomeEyebrow,
            textAlign: TextAlign.center,
            style: context.noor.tEyebrow,
          ),
          const SizedBox(height: 24),
          Text(
            Strings.introWelcomeTitle,
            textAlign: TextAlign.center,
            style: context.noor.tDisplay,
          ),
          const SizedBox(height: 16),
          Text(
            Strings.introWelcomeBody,
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
            Strings.introNoRushEyebrow,
            textAlign: TextAlign.center,
            style: context.noor.tEyebrow,
          ),
          const SizedBox(height: 6),
          Text(
            Strings.introNoRushTitle,
            textAlign: TextAlign.center,
            style: context.noor.tDisplay,
          ),
          const SizedBox(height: 16),
          Text(
            Strings.introNoRushBody,
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
// Step 3 — Last quick settings
// ===========================================================================

class _StepLastSettings extends StatelessWidget {
  const _StepLastSettings();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 60),
          // Bismillah calligraphy ornament — simple gold Arabic line; replace
          // with the actual SVG ornament when assets land.
          Text(
            'بِسْمِ اللَّهِ',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: IslamicDesignTokens.fontArabic,
              color: context.noor.secondary,
              fontSize: 38,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 28),
          Text(
            Strings.introLastStepEyebrow,
            textAlign: TextAlign.center,
            style: context.noor.tEyebrow,
          ),
          const SizedBox(height: 6),
          Text(
            Strings.introLastStepTitle,
            textAlign: TextAlign.center,
            style: context.noor.tDisplay,
          ),
          const SizedBox(height: 14),
          Text(
            Strings.introLastStepBody,
            textAlign: TextAlign.center,
            style: context.noor.tBody.copyWith(
              color: context.noor.inkMuted,
            ),
          ),
          const SizedBox(height: 28),
          _SettingCard(
            label: Strings.introLocationLabel,
            value: 'Seoul',
            onEdit: () {},
          ),
          const SizedBox(height: 12),
          _SettingCard(
            label: Strings.introMadhabLabel,
            value: 'Hanafi',
            onEdit: () {},
          ),
          const SizedBox(height: 12),
          _SettingCard(
            label: Strings.introLanguageLabel,
            value: 'English',
            onEdit: () {},
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _SettingCard extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onEdit;

  const _SettingCard({
    required this.label,
    required this.value,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 14, 12, 14),
      decoration: BoxDecoration(
        color: context.noor.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.noor.line, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: context.noor.tEyebrow.copyWith(
                    fontSize: 10,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontFamily: IslamicDesignTokens.fontDisplay,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: context.noor.ink,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onEdit,
            child: Text(
              Strings.introEdit,
              style: TextStyle(
                fontFamily: IslamicDesignTokens.fontDisplay,
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: context.noor.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ===========================================================================
// Bottom action bar — single Continue on step 1, Back/Continue on step 2,
// Back/Begin on step 3.
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
      return _PrimaryButton(label: Strings.introContinue, onTap: onContinue);
    }
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: _OutlineButton(label: Strings.introBack, onTap: onBack),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: _PrimaryButton(
            label: isLast ? Strings.introBegin : Strings.introContinue,
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
