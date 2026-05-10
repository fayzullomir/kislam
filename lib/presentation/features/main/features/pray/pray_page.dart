import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:koreaislam/core/gen/localization/strings.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/islamic_design_tokens.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/noor_tokens.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/islamic_mock_data.dart';
import 'package:koreaislam/presentation/support/cubit/base_page.dart';

import 'pray_cubit.dart';

@RoutePage()
class PrayPage extends BasePage<PrayCubit, PrayState, PrayEvent> {
  const PrayPage({super.key});

  @override
  void onWidgetCreated(BuildContext context) {}

  @override
  Widget onWidgetBuild(BuildContext context, PrayState state) {
    final steps = IslamicMockData.dhuhrGuide;
    final currentStep = state.currentStep.clamp(0, steps.length - 1);
    final step = steps[currentStep];
    final totalSteps = steps.length;

    return Scaffold(
      backgroundColor: context.noor.neutral,
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top settings icon (right-aligned).
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: () {
                    // TODO(phase-4): open prayer settings sheet.
                  },
                  icon: Icon(
                    Icons.settings_outlined,
                    color: context.noor.inkMuted,
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(Strings.prayGuideLabel,
                  style: context.noor.tEyebrow),
              const SizedBox(height: 6),
              Text(state.prayerName, style: context.noor.tDisplay),
              const SizedBox(height: 16),
              _SegmentedProgress(
                total: totalSteps,
                currentIndex: currentStep,
              ),
              const SizedBox(height: 14),
              Text(
                Strings.prayStepLabel(
                  '${currentStep + 1}',
                  '$totalSteps',
                ),
                style: context.noor.tEyebrow,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _PostureCard(posture: step.posture),
                      const SizedBox(height: 24),
                      Text(
                        step.eyebrow,
                        style: context.noor.tEyebrow.copyWith(
                          color: context.noor.secondaryInk,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(step.title, style: context.noor.tH1),
                      const SizedBox(height: 14),
                      Text(
                        step.body,
                        style: context.noor.tBody.copyWith(
                          color: context.noor.inkMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _NavigationButtons(
                backLabel: Strings.prayBack,
                nextLabel: Strings.prayNext,
                onBack: currentStep == 0
                    ? null
                    : () => cubit(context).back(),
                onNext: currentStep == totalSteps - 1
                    ? null
                    : () => cubit(context).next(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Segmented progress bar — N short pills, the [currentIndex] one is filled
// primary green, the rest are muted line color.
// ---------------------------------------------------------------------------

class _SegmentedProgress extends StatelessWidget {
  final int total;
  final int currentIndex;

  const _SegmentedProgress({required this.total, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(total, (i) {
        final isActive = i == currentIndex;
        final isCompleted = i < currentIndex;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i == total - 1 ? 0 : 6),
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                color: (isActive || isCompleted)
                    ? context.noor.primary
                    : context.noor.line,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        );
      }),
    );
  }
}

// ---------------------------------------------------------------------------
// Posture illustration card. Uses Material icons as placeholders until
// proper SVG illustrations land.
// ---------------------------------------------------------------------------

class _PostureCard extends StatelessWidget {
  final PrayerPosture posture;

  const _PostureCard({required this.posture});

  IconData _iconFor(PrayerPosture p) {
    switch (p) {
      case PrayerPosture.standing:
        return Icons.accessibility_new_rounded;
      case PrayerPosture.handsRaised:
        return Icons.front_hand_outlined;
      case PrayerPosture.bowed:
        return Icons.accessibility_rounded;
      case PrayerPosture.prostrated:
        return Icons.self_improvement_rounded;
      case PrayerPosture.sitting:
        return Icons.event_seat_outlined;
      case PrayerPosture.salam:
        return Icons.waving_hand_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        color: context.noor.neutralSage,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Center(
            child: Icon(
              _iconFor(posture),
              size: 96,
              color: context.noor.primary,
            ),
          ),
          Positioned(
            right: 14,
            bottom: 12,
            child: Text(
              Strings.prayPostureLabel,
              style: context.noor.tEyebrow.copyWith(
                color: context.noor.inkSoft,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Back / Next buttons — outlined Back, filled green Next. Either may be
// disabled (null callback) which renders a muted look + ignores taps.
// ---------------------------------------------------------------------------

class _NavigationButtons extends StatelessWidget {
  final String backLabel;
  final String nextLabel;
  final VoidCallback? onBack;
  final VoidCallback? onNext;

  const _NavigationButtons({
    required this.backLabel,
    required this.nextLabel,
    required this.onBack,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: _OutlinedBtn(label: backLabel, onTap: onBack),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: _FilledBtn(label: nextLabel, onTap: onNext),
        ),
      ],
    );
  }
}

class _OutlinedBtn extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const _OutlinedBtn({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;
    return Material(
      color: context.noor.surface,
      borderRadius: BorderRadius.circular(IslamicDesignTokens.radiusBtn),
      child: InkWell(
        borderRadius: BorderRadius.circular(IslamicDesignTokens.radiusBtn),
        onTap: onTap,
        child: Container(
          height: 52,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(IslamicDesignTokens.radiusBtn),
            border: Border.all(
              color: context.noor.line,
              width: 1,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: IslamicDesignTokens.fontDisplay,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: disabled
                  ? context.noor.inkSoft
                  : context.noor.ink,
            ),
          ),
        ),
      ),
    );
  }
}

class _FilledBtn extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const _FilledBtn({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;
    return Material(
      color: disabled
          ? context.noor.primary.withOpacity(0.45)
          : context.noor.primary,
      borderRadius: BorderRadius.circular(IslamicDesignTokens.radiusBtn),
      child: InkWell(
        borderRadius: BorderRadius.circular(IslamicDesignTokens.radiusBtn),
        onTap: onTap,
        child: Container(
          height: 52,
          alignment: Alignment.center,
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: IslamicDesignTokens.fontDisplay,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
