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
