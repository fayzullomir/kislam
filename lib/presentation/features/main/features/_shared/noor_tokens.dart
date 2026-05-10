import 'package:flutter/material.dart';

import 'islamic_design_tokens.dart';

/// Theme-aware Noor design system tokens.
///
/// Holds every color + color-bearing text style. Two const palettes
/// — [light] and [dark] — are picked by the [BuildContext.noor]
/// extension based on the current `Theme.of(context).brightness`.
///
/// Non-color tokens (spacing, font names, radii, durations, easing)
/// stay on [IslamicDesignTokens] as compile-time constants.
class NoorTokens {
  // ----- Brand -----
  final Color primary;
  final Color primaryInk;
  final Color primaryWash;

  final Color secondary;
  final Color secondaryInk;
  final Color secondaryWash;

  final Color tertiary;
  final Color tertiaryInk;
  final Color tertiaryWash;

  // ----- Neutral / paper -----
  final Color neutral;
  final Color neutralSand;
  final Color neutralSage;
  final Color paper2;
  final Color surface;

  // ----- Ink -----
  final Color ink;
  final Color inkMuted;
  final Color inkSoft;
  final Color line;
  final Color lineStrong;

  // ----- State -----
  final Color success;
  final Color warning;
  final Color danger;
  final Color info;

  const NoorTokens._({
    required this.primary,
    required this.primaryInk,
    required this.primaryWash,
    required this.secondary,
    required this.secondaryInk,
    required this.secondaryWash,
    required this.tertiary,
    required this.tertiaryInk,
    required this.tertiaryWash,
    required this.neutral,
    required this.neutralSand,
    required this.neutralSage,
    required this.paper2,
    required this.surface,
    required this.ink,
    required this.inkMuted,
    required this.inkSoft,
    required this.line,
    required this.lineStrong,
    required this.success,
    required this.warning,
    required this.danger,
    required this.info,
  });

  /// Light palette — warm off-white canvas, deep Islamic green primary.
  static const NoorTokens light = NoorTokens._(
    primary: Color(0xFF0F5132),
    primaryInk: Color(0xFF0A3821),
    primaryWash: Color(0xFFE8EEEA),
    secondary: Color(0xFFC9A961),
    secondaryInk: Color(0xFFA88842),
    secondaryWash: Color(0xFFF6EED9),
    tertiary: Color(0xFF7A9084),
    tertiaryInk: Color(0xFF5F7468),
    tertiaryWash: Color(0xFFEEF2ED),
    neutral: Color(0xFFFAF8F3),
    neutralSand: Color(0xFFF5EDDB),
    neutralSage: Color(0xFFEEF2ED),
    paper2: Color(0xFFF3EFE4),
    surface: Color(0xFFFFFFFF),
    ink: Color(0xFF1A1C1A),
    inkMuted: Color(0xFF5A6159),
    inkSoft: Color(0xFF8A8F86),
    line: Color(0xFFE8E3D6),
    lineStrong: Color(0xFFD8D2C1),
    success: Color(0xFF3E7A52),
    warning: Color(0xFFB47A2E),
    danger: Color(0xFFA63A2E),
    info: Color(0xFF4A6E85),
  );

  /// Dark palette — warm charcoal "paper", lifted greens. Never true black.
  static const NoorTokens dark = NoorTokens._(
    primary: Color(0xFF4A9B6E),
    primaryInk: Color(0xFF6BB78A),
    primaryWash: Color(0xFF1F3329),
    secondary: Color(0xFFD4B876),
    secondaryInk: Color(0xFFE6CE99),
    secondaryWash: Color(0xFF2E2819),
    tertiary: Color(0xFF93A89B),
    tertiaryInk: Color(0xFFAEC2B6),
    tertiaryWash: Color(0xFF242A26),
    neutral: Color(0xFF1E1C17),
    neutralSand: Color(0xFF2A251C),
    neutralSage: Color(0xFF1F2420),
    paper2: Color(0xFF252219),
    // Surface (cards) lifts a notch above the "paper" so cards stay legible.
    surface: Color(0xFF2A2620),
    ink: Color(0xFFEDE7D4),
    inkMuted: Color(0xFFA8A396),
    inkSoft: Color(0xFF7A7668),
    line: Color(0xFF322E24),
    lineStrong: Color(0xFF433E30),
    success: Color(0xFF6BB78A),
    warning: Color(0xFFD4A25F),
    danger: Color(0xFFD46A5D),
    info: Color(0xFF7A9CB5),
  );

  // ----- Type styles (color-aware) -----
  // Instance getters so the bundled color follows the active palette.

  TextStyle get tDisplay => TextStyle(
        fontFamily: IslamicDesignTokens.fontDisplay,
        fontSize: 34,
        height: 1.18,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.34,
        color: ink,
      );

  TextStyle get tH1 => TextStyle(
        fontFamily: IslamicDesignTokens.fontDisplay,
        fontSize: 28,
        height: 1.22,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.14,
        color: ink,
      );

  TextStyle get tH2 => TextStyle(
        fontFamily: IslamicDesignTokens.fontDisplay,
        fontSize: 22,
        height: 1.28,
        fontWeight: FontWeight.w600,
        color: ink,
      );

  TextStyle get tH3 => TextStyle(
        fontFamily: IslamicDesignTokens.fontDisplay,
        fontSize: 18,
        height: 1.35,
        fontWeight: FontWeight.w600,
        color: ink,
      );

  TextStyle get tBody => TextStyle(
        fontFamily: IslamicDesignTokens.fontBody,
        fontSize: 16,
        height: 1.6,
        fontWeight: FontWeight.w400,
        color: ink,
      );

  TextStyle get tBodySm => TextStyle(
        fontFamily: IslamicDesignTokens.fontBody,
        fontSize: 14,
        height: 1.55,
        fontWeight: FontWeight.w400,
        color: inkMuted,
      );

  TextStyle get tLabel => TextStyle(
        fontFamily: IslamicDesignTokens.fontBody,
        fontSize: 13,
        height: 1.4,
        fontWeight: FontWeight.w500,
        color: ink,
      );

  TextStyle get tCaption => TextStyle(
        fontFamily: IslamicDesignTokens.fontBody,
        fontSize: 12,
        height: 1.4,
        fontWeight: FontWeight.w400,
        color: inkSoft,
      );

  /// Eyebrow — uppercase, tracked. "NEXT PRAYER", "QIBLA", section labels.
  TextStyle get tEyebrow => TextStyle(
        fontFamily: IslamicDesignTokens.fontBody,
        fontSize: 11,
        height: 1.2,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.32,
        color: inkMuted,
      );

  TextStyle get tArabic => TextStyle(
        fontFamily: IslamicDesignTokens.fontArabic,
        fontSize: 28,
        height: 2.0,
        color: ink,
      );

  // ----- Elevation (shadow tints adapt to palette) -----
  List<BoxShadow> get shadowSheet => [
        BoxShadow(
          color: Colors.black.withOpacity(this == NoorTokens.dark ? 0.40 : 0.08),
          blurRadius: 32,
          offset: const Offset(0, 8),
          spreadRadius: -8,
        ),
      ];

  List<BoxShadow> get shadowPop => [
        BoxShadow(
          color: Colors.black.withOpacity(this == NoorTokens.dark ? 0.30 : 0.06),
          blurRadius: 8,
          offset: const Offset(0, 2),
          spreadRadius: -2,
        ),
      ];
}

/// `context.noor` returns the active [NoorTokens] palette.
///
/// Hooks into Flutter's existing `Theme.of(context).brightness`, which
/// `Application` already toggles via `_appThemeModeChannel` — when the
/// user flips Themes, the whole tree rebuilds and every `context.noor`
/// callsite resolves to the right palette.
extension NoorContext on BuildContext {
  NoorTokens get noor => Theme.of(this).brightness == Brightness.dark
      ? NoorTokens.dark
      : NoorTokens.light;
}
