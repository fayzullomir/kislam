import 'package:flutter/material.dart';

abstract class StaticColors {
  static const dodgerBlue = Color(0xFF3f9cfb);
  static const white = Color(0xFFFFFFFF);
  static const cadetBlue = Color(0xFF9EABBE);
  static const innerCardColor = Color(0x1AC1C1C1);
  static const cardColor = Color(0x1AFFFFFF);

  // static const brightGray = Color(0xFFF3EFE5);
  static const brightGray = Color(0xFFE3E5E5);
  static const colorPrimary = Color(0xFF02183A);
  static const colorAccent = Color(0xFFDFB304);
  static const colorAccentVariant = Color(0xFF7CF6AD);
  static const buttonColor = colorAccent;
  static const progressBarBackground = Color(0x597CF6AD);
  static const progressBarForeground = Color(0xFF7CF6AD);

  static const colorError = Color(0xFF832323);

  static const inputBackgroundColor = Color(0xFFFAF9FF);
  static const inputStrokeColor = Color(0xFFDFE2E9);

  // static const textColorPrimary = Color(0xFF41455F);
  static const textColorPrimary = Color(0xFF000000);

  // static const textColorSecondary = Color(0xFF5A5D83);
  // static const textColorSecondary = context.textSecondary;
  static const textColorSecondary = Color(0xFFA8A8A8);

  static const iconAccent = StaticColors.colorPrimary;
  static const iconPrimaryLight = StaticColors.textColorPrimary;
  static const iconPrimaryDark = StaticColors.white;
  static const iconSecondary = Color(0xFF91A3EF);

  static Color shimmerBaseColor = Color(0xFFB1AFAF).withValues(alpha: 0.5);
  static const shimmerHighLightColor = Colors.white;

  static const backgroundLightColor = Color(0xFFF2F4FB);
  static const backgroundDarkColor = Color(0xFF1E1E1E);

  static const toastDefaultBackgroundColor = Color(0xFF013D8C);
  static const toastSuccessBackgroundColor = Color(0xFF54931B);
  static const toastErrorBackgroundColor = Color(0xFFA93232);

  static const bottomSelectColor = StaticColors.colorAccent;
  static const bottomUnSelectColor = Color(0xFF949494);

  static const statusPending = Color(0xFFF79500);
  static const statusRejected = Color(0xFFFB577C);
  static const statusCancelled = Color(0xFFFB577C);
  static const statusConfirmed = Color(0xFF4DA6FF);
  static const statusCompleted = Color(0xFF00AC59);
}
