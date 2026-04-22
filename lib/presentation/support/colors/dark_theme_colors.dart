import 'dart:ui';

import 'package:injectable/injectable.dart';
import 'package:koreaislam/presentation/support/colors/static_colors.dart';
import 'package:koreaislam/presentation/support/colors/theme_colors.dart';

@lazySingleton
class DarkThemeColors extends ThemeColors {
  @override
  Color get backgroundColor => StaticColors.backgroundDarkColor;

  @override
  Color get primary => StaticColors.colorPrimary;

  @override
  Color get onPrimary => StaticColors.white;

  @override
  Color get textPrimary => StaticColors.white;

  @override
  Color get textAccent => StaticColors.dodgerBlue;

  @override
  Color get textSecondary => StaticColors.textColorSecondary;

  @override
  Color get textTertiary => StaticColors.cadetBlue;

  @override
  Color get textPrimaryInverse => Color(0xFF8C8989);

  @override
  Color get borderColor => StaticColors.brightGray;

  @override
  Color get buttonPrimary => StaticColors.buttonColor;

  @override
  Color get inputBackground => Color(0x80F6F7FC); //Color(0xFF333333);

  @override
  Color get iconPrimary => StaticColors.iconPrimaryDark;

  @override
  Color get iconSecondary => StaticColors.iconSecondary;
}
