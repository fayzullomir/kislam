import 'package:flutter/material.dart';
import 'package:koreaislam/core/extensions/text_extensions.dart';
import 'package:koreaislam/presentation/support/colors/static_colors.dart';
import 'package:koreaislam/presentation/support/extensions/color_extension.dart';

class MaterialTextButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final Color? textColor;
  final double textSize;

  const MaterialTextButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.textColor,
    this.textSize = 14,
  }) : super(key: key);


  bool isClickedRecently(DateTime? lastClickTime) {
    if (lastClickTime == null) return false;
    var now = DateTime.now();
    return (lastClickTime.difference(now).inMilliseconds) > -1000;
  }

  @override
  Widget build(BuildContext context) {
    DateTime? clickTime;

    final onButtonPressed = isEnabled
        ? () {
            if (isLoading) {
              return;
            } else if (isClickedRecently(clickTime)) {
              return;
            } else {
              clickTime = DateTime.now();
              onPressed?.call();
            }
          }
        : null;

    var defaultTextColor = StaticColors.colorAccent
        .withAlpha(isEnabled ? 255 : (0.75 * 255).round());
    return TextButton(
      onPressed: onButtonPressed,
      style: TextButton.styleFrom(
        textStyle: TextStyle(color: textColor ?? context.colorAccent),
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Row(
        children: [
          text.s(textSize)
              .w(500)
              .c(textColor ?? (defaultTextColor)),
          Visibility(visible: isLoading, child: SizedBox(width: 12)),
          Visibility(
            visible: isLoading,
            child: SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                color: textColor ?? defaultTextColor,
                strokeWidth: 1.5,
                strokeAlign: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
