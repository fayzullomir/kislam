import 'package:flutter/material.dart';

/// Shared design tokens that recreate the "Al-Muroshiru" Stitch mock.
/// Kept local to the main/features module so the existing app theme is
/// not affected.
class IslamicDesignTokens {
  IslamicDesignTokens._();

  static const Color primary = Color(0xFF0F3D2E);
  static const Color primaryDark = Color(0xFF0B3326);
  static const Color primarySoft = Color(0x1A0F3D2E);

  static const Color accent = Color(0xFFBF9A3A);
  static const Color accentSoft = Color(0xFFE9D38A);
  static const Color accentPill = Color(0xFFF4E4B5);

  static const Color background = Color(0xFFF7F2E4);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFEDE6D4);

  static const Color textPrimary = Color(0xFF11140F);
  static const Color textSecondary = Color(0xFF55584F);
  static const Color textMuted = Color(0xFF8B8D83);
  static const Color textAccent = Color(0xFF0F3D2E);

  static const Color divider = Color(0xFFE3DDCB);
  static const Color dangerRed = Color(0xFFE10202);

  static const double radiusLg = 24;
  static const double radiusMd = 18;
  static const double radiusSm = 12;
}
