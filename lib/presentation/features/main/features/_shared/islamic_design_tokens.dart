import 'package:flutter/material.dart';

/// Noor design system tokens for the Korean-language Islamic companion app.
///
/// Mirrors the K-Islam UI Kit produced in Claude Design. Existing token names
/// are preserved (backward compatibility with the rest of the module) — only
/// values are refreshed. New tokens (secondary/tertiary/ink-soft/sand/sage,
/// type scale, elevation, durations) are added below the legacy block.
class IslamicDesignTokens {
  IslamicDesignTokens._();

  // ===========================================================================
  // Legacy token names — kept so existing widgets keep compiling.
  // Values updated to match the Noor palette.
  // ===========================================================================

  /// Deep Islamic green — brand primary.
  static const Color primary = Color(0xFF0F5132);

  /// Pressed/ink variant of primary.
  static const Color primaryDark = Color(0xFF0A3821);

  /// Faint primary tint (≈10% alpha) for selected rows / soft chips.
  static const Color primarySoft = Color(0x1A0F5132);

  /// Warm gold — secondary brand accent.
  static const Color accent = Color(0xFFC9A961);
  static const Color accentSoft = Color(0xFFE6CE99);
  static const Color accentPill = Color(0xFFF6EED9);

  /// Warm off-white canvas.
  static const Color background = Color(0xFFFAF8F3);
  static const Color surface = Color(0xFFFFFFFF);

  /// Sand — used for the home "Next prayer" hero card.
  static const Color surfaceMuted = Color(0xFFF5EDDB);

  static const Color textPrimary = Color(0xFF1A1C1A);
  static const Color textSecondary = Color(0xFF5A6159);
  static const Color textMuted = Color(0xFF8A8F86);
  static const Color textAccent = Color(0xFF0F5132);

  static const Color divider = Color(0xFFE8E3D6);
  static const Color dangerRed = Color(0xFFA63A2E);

  static const double radiusLg = 24;
  static const double radiusMd = 18;
  static const double radiusSm = 12;

  // ===========================================================================
  // New Noor tokens (use these in newly built screens)
  // ===========================================================================

  // ----- Color: brand -----
  static const Color primaryInk = Color(0xFF0A3821);
  static const Color primaryWash = Color(0xFFE8EEEA);

  static const Color secondary = Color(0xFFC9A961);
  static const Color secondaryInk = Color(0xFFA88842);
  static const Color secondaryWash = Color(0xFFF6EED9);

  static const Color tertiary = Color(0xFF7A9084);
  static const Color tertiaryInk = Color(0xFF5F7468);
  static const Color tertiaryWash = Color(0xFFEEF2ED);

  // ----- Color: neutral / paper -----
  static const Color neutral = Color(0xFFFAF8F3);
  static const Color neutralSand = Color(0xFFF5EDDB);
  static const Color neutralSage = Color(0xFFEEF2ED);
  static const Color paper2 = Color(0xFFF3EFE4);

  // ----- Color: ink -----
  static const Color ink = Color(0xFF1A1C1A);
  static const Color inkMuted = Color(0xFF5A6159);
  static const Color inkSoft = Color(0xFF8A8F86);
  static const Color line = Color(0xFFE8E3D6);
  static const Color lineStrong = Color(0xFFD8D2C1);

  // ----- Color: state -----
  static const Color success = Color(0xFF3E7A52);
  static const Color warning = Color(0xFFB47A2E);
  static const Color danger = Color(0xFFA63A2E);
  static const Color info = Color(0xFF4A6E85);

  // ----- Elevation -----
  static const List<BoxShadow> shadowSheet = [
    BoxShadow(
      color: Color(0x14000000), // ~8% on warm bg
      blurRadius: 32,
      offset: Offset(0, 8),
      spreadRadius: -8,
    ),
  ];
  static const List<BoxShadow> shadowPop = [
    BoxShadow(
      color: Color(0x0F000000), // ~6%
      blurRadius: 8,
      offset: Offset(0, 2),
      spreadRadius: -2,
    ),
  ];

  // ----- Radii (extended) -----
  static const double radiusChip = 4;
  static const double radiusBtn = 8;
  static const double radiusCard = 12;
  static const double radiusPill = 999;

  // ----- Spacing (4pt base) -----
  static const double s1 = 4;
  static const double s2 = 8;
  static const double s3 = 12;
  static const double s4 = 16;
  static const double s5 = 20;
  static const double s6 = 24;
  static const double s7 = 32;
  static const double s8 = 40;
  static const double s9 = 56;
  static const double s10 = 72;
  static const double s11 = 96;

  // ----- Type families -----
  // App ships Inter today; Manrope / Plus Jakarta / Amiri Quran are loaded as
  // assets in a follow-up step. The constants below give us a single source
  // of truth so swapping the family later is one line per font.
  static const String fontDisplay = 'Manrope';
  static const String fontBody = 'Plus Jakarta Sans';
  static const String fontArabic = 'Amiri Quran';
  static const String fontKorean = 'Pretendard Variable';

  // ----- Type scale (display = Manrope; body = Jakarta) -----
  static const TextStyle tDisplay = TextStyle(
    fontFamily: fontDisplay,
    fontSize: 34,
    height: 1.18,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.34, // -0.01em on 34px
    color: ink,
  );
  static const TextStyle tH1 = TextStyle(
    fontFamily: fontDisplay,
    fontSize: 28,
    height: 1.22,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.14,
    color: ink,
  );
  static const TextStyle tH2 = TextStyle(
    fontFamily: fontDisplay,
    fontSize: 22,
    height: 1.28,
    fontWeight: FontWeight.w600,
    color: ink,
  );
  static const TextStyle tH3 = TextStyle(
    fontFamily: fontDisplay,
    fontSize: 18,
    height: 1.35,
    fontWeight: FontWeight.w600,
    color: ink,
  );
  static const TextStyle tBody = TextStyle(
    fontFamily: fontBody,
    fontSize: 16,
    height: 1.6,
    fontWeight: FontWeight.w400,
    color: ink,
  );
  static const TextStyle tBodySm = TextStyle(
    fontFamily: fontBody,
    fontSize: 14,
    height: 1.55,
    fontWeight: FontWeight.w400,
    color: inkMuted,
  );
  static const TextStyle tLabel = TextStyle(
    fontFamily: fontBody,
    fontSize: 13,
    height: 1.4,
    fontWeight: FontWeight.w500,
    color: ink,
  );
  static const TextStyle tCaption = TextStyle(
    fontFamily: fontBody,
    fontSize: 12,
    height: 1.4,
    fontWeight: FontWeight.w400,
    color: inkSoft,
  );

  /// Eyebrow — uppercase, tracked. Used for section labels and small headings
  /// like "NEXT PRAYER", "TODAY'S WISDOM", "QIBLA".
  static const TextStyle tEyebrow = TextStyle(
    fontFamily: fontBody,
    fontSize: 11,
    height: 1.2,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.32, // 0.12em on 11px
    color: inkMuted,
  );

  /// Qur'an verse default. Right-aligned, plaintext bidi.
  static const TextStyle tArabic = TextStyle(
    fontFamily: fontArabic,
    fontSize: 28,
    height: 2.0,
    color: ink,
  );

  // ----- Motion -----
  static const Curve easeNoor = Cubic(0.2, 0.7, 0.2, 1);
  static const Duration durFast = Duration(milliseconds: 180);
  static const Duration durBase = Duration(milliseconds: 260);
  static const Duration durSlow = Duration(milliseconds: 420);
  static const Duration durReverent = Duration(milliseconds: 600);
}
