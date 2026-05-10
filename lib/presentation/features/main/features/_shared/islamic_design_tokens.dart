import 'package:flutter/material.dart';

/// Palette-independent Noor tokens — radii, spacing, font names, motion.
///
/// Theme-aware values (colors + color-bearing text styles) live on
/// `NoorTokens` and are read through `context.noor.*`. This class stays
/// `static const` because none of these values change between light and
/// dark mode.
class IslamicDesignTokens {
  IslamicDesignTokens._();

  // ----- Radii -----
  static const double radiusChip = 4;
  static const double radiusBtn = 8;
  static const double radiusCard = 12;
  static const double radiusSm = 12;
  static const double radiusMd = 18;
  static const double radiusLg = 24;
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
  // App ships Inter today; Manrope / Plus Jakarta / Amiri Quran load from
  // assets/fonts/ once the user drops the .ttf files in. Until then the
  // engine falls back to the system font for these families.
  static const String fontDisplay = 'Manrope';
  static const String fontBody = 'Plus Jakarta Sans';
  static const String fontArabic = 'Amiri Quran';
  static const String fontKorean = 'Pretendard Variable';

  // ----- Motion -----
  static const Curve easeNoor = Cubic(0.2, 0.7, 0.2, 1);
  static const Duration durFast = Duration(milliseconds: 180);
  static const Duration durBase = Duration(milliseconds: 260);
  static const Duration durSlow = Duration(milliseconds: 420);
  static const Duration durReverent = Duration(milliseconds: 600);
}
