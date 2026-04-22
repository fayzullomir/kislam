import 'package:flutter/material.dart';
import 'package:koreaislam/presentation/support/colors/dark_theme_colors.dart';
import 'package:koreaislam/presentation/support/colors/light_theme_colors.dart';
import 'package:koreaislam/presentation/support/colors/static_colors.dart';
import 'package:koreaislam/presentation/support/colors/theme_colors.dart';
import 'package:koreaislam/presentation/support/extensions/blur_effect.dart';

extension ColorExtension on BuildContext {
  ThemeColors get colors => isDarkMode ? DarkThemeColors() : LightThemeColors();

  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  Brightness get brightness => Theme.of(this).brightness;

  ThemeData get theme => Theme.of(this);

  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  Color get colorPrimary => StaticColors.colorPrimary;

  Color get colorAccent => StaticColors.colorAccent;

  Color get colorDivider => isDarkMode ? Color(0xFF424242) : Color(0xFFD1CFCF);

  /// Background Colors

  Color get pageBackgroundColor =>
      isDarkMode ? Color(0xFF000000) : Color(0xFFF4F4F4);
  // isDarkMode ? Color(0xFF0F1115) : Color(0xFFF4F4F4);

  Color get backgroundGreyColor =>
      isDarkMode ? Color(0xFF121212) : Color(0xFFFFFFFF);

  // Color get bottomSheetColor => Theme.of(this).colorScheme.surface;
  Color get bottomSheetColor =>
      isDarkMode ? Color(0xFF121212) : Color(0xFFF2F4FB);

  /// Component Colors

  Color get bottomNavigationColor =>
      Theme.of(this).colorScheme.surface;

  Color get appBarColor =>
      isDarkMode ? Color(0xFF333333) : Color(0xFFFFFFFF);
      // isDarkMode ? Color(0xFF0F1115) : Color(0xFFFFFFFF);

  Color get tabBarActiveColor =>
      isDarkMode ? Color(0xFF333333) : Color(0xFFFFFFFF);

  Color get cardColor => isDarkMode ? Color(0xFF333333) : Color(0xFFFFFFFF);

  Color get customCardBackground =>
      isDarkMode ? Color(0xFF272727) : Color(0xFFFFFFFF);
      // isDarkMode ? Color(0xFF232323) : Color(0xFFFFFFFF);

  Color get containerColorGrey =>
      (isDarkMode ? Color(0xFF333333) : Color(0xFFFBFBFB))
          .withAlpha((255 * itemsOpacity).round());

  Color get containerBorderColor =>
      isDarkMode ? Color(0xFF333333) : Color(0xFFDDDDDD);

  Color get containerInfoBcColor =>
      isDarkMode ? Color(0xFF333333) : Color(0xFFF8F8F8);

  Color get cardStrokeColor => Theme.of(this).cardColor;

  Color get textPrimary => colors.textPrimary;

  Color get textSecondary => colors.textSecondary;

  Color get textTertiary => colors.textTertiary;

  Color get textPrimaryInverse => colors.textPrimaryInverse;

  Color get textHint => isDarkMode ? colors.textPrimary : colors.textSecondary;

  Color get inputBackgroundColor =>
      isDarkMode ? Color(0xFF1C1C1E) : Color(0x25BFBFBF);

  Color get inputStrokeActiveColor => StaticColors.colorAccent;

  Color get inputStrokeColor =>
      isDarkMode ? Color(0xFF424242) : Color(0xFFA5A5A5);

  Color get searchInputStrokeColor =>
      Colors.white.withAlpha((255 * .5).round());

  Color get inputTextColor => Colors.white;

  Color get inputHintTextColor => Colors.white.withAlpha((255 * .8).round());

  Color get iconAccent => StaticColors.colorAccent;

  Color get iconPrimary =>
      isDarkMode ? StaticColors.iconPrimaryDark : StaticColors.iconPrimaryLight;

  Color get iconPrimaryInverse =>
      isDarkMode ? StaticColors.iconPrimaryLight : StaticColors.iconPrimaryDark;

  Color get iconSecondary => colors.iconSecondary;

  // Color get primaryLight => isDarkMode ? Color(0xFF7CF6AD) : Color(0xFF6771D2);
  Color get primaryLight => Color(0xFF6771D2);

  Color get bottomNavColor => isDarkMode ? Color(0xFF2E2E2E) : Colors.white;

  Color get materialElevatedButtonBackground => StaticColors.buttonColor;

  Color get materialOutlinedButtonStroke =>
      // isDarkMode ? Color(0xFF424242) : Color(0xFF595858);
  StaticColors.buttonColor;

  Color get materialOutlinedButtonBackground =>
      // isDarkMode ? Color(0xFF333333) : Color(0x4DE1E1E1);
  Colors.transparent;

  Gradient get dateListGradient => isDarkMode
      ? LinearGradient(
          colors: const [
            Color(0xFF15D2E9),
            Color(0xFF7CF6AD),
            Color(0xFFBCF489),
          ].map((color) => color.withAlpha((255 * .6).round())).toList(),
          begin: Alignment.bottomLeft,
          end: Alignment.topRight)
      : _darkModeGradient;

  Color get borderStroke => isDarkMode ? Color(0xFF424242) : Color(0xFFD1CFCF);

  Color get bottomBarSelectColor => StaticColors.colorAccent;

  Color get bottomBarUnSelectColor =>
      isDarkMode ? Color(0xFFA0A0A0) : Color(0xFF949494);

  Gradient get _darkModeGradient => LinearGradient(colors: const [
        Color(0xFF6771D2),
        Color(0xFFAD74D3),
      ], begin: Alignment.centerLeft, end: Alignment.centerRight);
}
