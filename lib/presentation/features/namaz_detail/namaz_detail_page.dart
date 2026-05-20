import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:koreaislam/core/gen/localization/strings.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/islamic_design_tokens.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/namaz_mock_data.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/noor_tokens.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/pose_figure.dart';

/// Step-by-step namaz guide. Each step is a collapsible block with a
/// numbered eyebrow + title + description + (optional) PoseFigure
/// illustration. A "A+" toggle at the top cycles the body font scale.
///
/// Reached from `PrayPage` when the user taps a rakat-count chip on a
/// prayer card. The step sequence is built by
/// `NamazMockData.stepKeysFor(variant)`.
@RoutePage()
class NamazDetailPage extends StatefulWidget {
  final String namazId;
  final String variantId;

  const NamazDetailPage({
    super.key,
    required this.namazId,
    required this.variantId,
  });

  @override
  State<NamazDetailPage> createState() => _NamazDetailPageState();
}

class _NamazDetailPageState extends State<NamazDetailPage> {
  /// Three discrete scale steps — matches the design's button cycle.
  double _fontScale = 1.0;

  void _cycleFontScale() {
    setState(() {
      if (_fontScale == 1.0) {
        _fontScale = 1.15;
      } else if (_fontScale == 1.15) {
        _fontScale = 1.3;
      } else {
        _fontScale = 1.0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final n = context.noor;
    final localeCode = context.locale.languageCode;
    final namaz = NamazMockData.byId(widget.namazId);
    final variant = namaz.variants.firstWhere(
      (v) => v.id == widget.variantId,
      orElse: () => namaz.variants.first,
    );
    final stepKeys = NamazMockData.stepKeysFor(variant);
    final copy = NamazStepCopy(localeCode);
    final prayerName = namaz.localized(localeCode);
    final variantName = variant.localized(localeCode);

    return Scaffold(
      backgroundColor: n.neutral,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _DetailTopBar(
              title: '$prayerName · $variantName',
              fontScale: _fontScale,
              onBack: () => Navigator.of(context).maybePop(),
              onFontScale: _cycleFontScale,
            ),
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                padding: const EdgeInsets.only(bottom: 20),
                itemCount: stepKeys.length,
                itemBuilder: (_, i) {
                  final step = copy.contentFor(
                    stepKeys[i],
                    prayerName: prayerName,
                    variantName: variantName,
                  );
                  return _StepBlock(
                    index: i + 1,
                    step: step,
                    fontScale: _fontScale,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Top bar — back arrow, title + variant, font-scale toggle.
// ---------------------------------------------------------------------------

class _DetailTopBar extends StatelessWidget {
  final String title;
  final double fontScale;
  final VoidCallback onBack;
  final VoidCallback onFontScale;

  const _DetailTopBar({
    required this.title,
    required this.fontScale,
    required this.onBack,
    required this.onFontScale,
  });

  @override
  Widget build(BuildContext context) {
    final n = context.noor;
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: n.line, width: 0.5),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(8, 6, 12, 8),
      child: Row(
        children: [
          InkResponse(
            onTap: onBack,
            radius: 22,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(
                Icons.chevron_left_rounded,
                color: n.ink,
                size: 22,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: IslamicDesignTokens.fontDisplay,
                  color: n.ink,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          Material(
            color: n.surface,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: onFontScale,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: n.line, width: 0.5),
                ),
                child: Text(
                  fontScale == 1.0
                      ? 'A+'
                      : fontScale == 1.15
                          ? 'A++'
                          : 'A',
                  style: TextStyle(
                    fontFamily: IslamicDesignTokens.fontBody,
                    color: n.inkMuted,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Single step block — numbered eyebrow header + collapsible body with
// optional pose illustration.
// ---------------------------------------------------------------------------

class _StepBlock extends StatefulWidget {
  final int index;
  final NamazStepContent step;
  final double fontScale;

  const _StepBlock({
    required this.index,
    required this.step,
    required this.fontScale,
  });

  @override
  State<_StepBlock> createState() => _StepBlockState();
}

class _StepBlockState extends State<_StepBlock> {
  bool _open = true;

  @override
  Widget build(BuildContext context) {
    final n = context.noor;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          onTap: () => setState(() => _open = !_open),
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: n.paper2,
              border: Border(
                bottom: BorderSide(color: n.line, width: 0.5),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 22,
                  height: 22,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: n.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${widget.index}',
                    style: const TextStyle(
                      fontFamily: IslamicDesignTokens.fontBody,
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.step.title,
                    style: TextStyle(
                      fontFamily: IslamicDesignTokens.fontDisplay,
                      color: n.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
                AnimatedRotation(
                  turns: _open ? 0.25 : 0,
                  duration: IslamicDesignTokens.durFast,
                  child: Icon(
                    Icons.chevron_right_rounded,
                    color: n.inkSoft,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_open)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: widget.step.body,
                        style: TextStyle(
                          fontFamily: IslamicDesignTokens.fontBody,
                          color: n.ink,
                          fontSize: 14 * widget.fontScale,
                          height: 1.6,
                        ),
                      ),
                      if (widget.step.hasMoreLink)
                        TextSpan(
                          text: ' ${Strings.namazStepMore}',
                          style: TextStyle(
                            fontFamily: IslamicDesignTokens.fontBody,
                            color: n.primary,
                            fontSize: 14 * widget.fontScale,
                            fontWeight: FontWeight.w600,
                            height: 1.6,
                          ),
                        ),
                    ],
                  ),
                ),
                if (widget.step.pose != null) ...[
                  const SizedBox(height: 12),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: n.primaryWash,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: PoseFigure(
                        pose: widget.step.pose!,
                        size: 86,
                        color: n.primary,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }
}
