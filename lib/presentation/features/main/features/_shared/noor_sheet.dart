import 'package:flutter/material.dart';

import 'islamic_design_tokens.dart';
import 'noor_tokens.dart';

/// Shared building blocks for the Noor-styled bottom sheets — used by
/// notification settings, language picker, and theme picker.
///
/// Layout pattern:
///   ┌──────────────────────────┐
///   │           ▔▔             │  NoorSheetHandle
///   │  EYEBROW                 │  NoorSheetHeader
///   │  Subtitle text           │
///   │  ┌────────────────────┐  │
///   │  │ Row title       ✓  │  │  NoorSheetSelectableRow
///   │  ├────────────────────┤  │  NoorSheetRowDivider
///   │  │ Row title          │  │
///   │  └────────────────────┘  │
///   └──────────────────────────┘

// ---------------------------------------------------------------------------

/// Top handle bar (36×4 pill) — visual affordance that the sheet drags.
class NoorSheetHandle extends StatelessWidget {
  const NoorSheetHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Center(
        child: Container(
          width: 36,
          height: 4,
          decoration: BoxDecoration(
            color: context.noor.line,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------

/// Eyebrow (uppercase, tracked) + subtitle pair, left-aligned with the
/// 20px sheet padding.
class NoorSheetHeader extends StatelessWidget {
  final String eyebrow;
  final String subtitle;

  const NoorSheetHeader({
    super.key,
    required this.eyebrow,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(eyebrow, style: context.noor.tEyebrow),
          const SizedBox(height: 6),
          Text(subtitle, style: context.noor.tBodySm),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------

/// Hairline row divider, indented by the sheet's 20px padding so it never
/// touches the rounded card edges.
class NoorSheetRowDivider extends StatelessWidget {
  const NoorSheetRowDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Divider(
        height: 1,
        thickness: 1,
        color: context.noor.line,
      ),
    );
  }
}

// ---------------------------------------------------------------------------

/// Tappable row used inside language / theme pickers. Shows the title
/// on the left and a primary-green check icon on the right when selected.
class NoorSheetSelectableRow extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool selected;
  final VoidCallback onTap;

  const NoorSheetSelectableRow({
    super.key,
    required this.title,
    required this.selected,
    required this.onTap,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: IslamicDesignTokens.fontDisplay,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: context.noor.ink,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(subtitle!, style: context.noor.tBodySm),
                  ],
                ],
              ),
            ),
            // Reserve the right-side gutter even when unselected so the
            // title doesn't shift horizontally on tap.
            SizedBox(
              width: 24,
              height: 24,
              child: selected
                  ? Icon(
                      Icons.check_rounded,
                      size: 22,
                      color: context.noor.primary,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------

/// Pill-shaped toggle that mirrors the new design — primary green when ON,
/// muted sand (or charcoal in dark mode) when OFF, white thumb with a soft
/// drop shadow. Replaces `Switch.adaptive` so the look stays consistent
/// across iOS / Android.
class NoorSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const NoorSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  static const double _width = 50;
  static const double _height = 30;
  static const double _padding = 3;

  @override
  Widget build(BuildContext context) {
    final n = context.noor;
    final trackColor = value ? n.primary : n.lineStrong;
    final thumbDiameter = _height - _padding * 2;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: IslamicDesignTokens.durFast,
        curve: IslamicDesignTokens.easeNoor,
        width: _width,
        height: _height,
        padding: const EdgeInsets.all(_padding),
        decoration: BoxDecoration(
          color: trackColor,
          borderRadius: BorderRadius.circular(_height / 2),
        ),
        child: AnimatedAlign(
          duration: IslamicDesignTokens.durFast,
          curve: IslamicDesignTokens.easeNoor,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: thumbDiameter,
            height: thumbDiameter,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.18),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------

/// Convenience scaffold for a Noor-styled bottom sheet — wraps the
/// children in [Material], a SafeArea, and a scroll view so individual
/// sheets only declare their content.
class NoorSheetScaffold extends StatelessWidget {
  final List<Widget> children;

  const NoorSheetScaffold({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.noor.neutral,
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const NoorSheetHandle(),
              const SizedBox(height: 8),
              ...children,
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
