import 'package:koreaislam/core/extensions/text_extensions.dart';
import 'package:koreaislam/presentation/support/extensions/color_extension.dart';
import 'package:flutter/material.dart';

class MaterialOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final bool loading;
  final bool enabled;
  final bool selected;
  final Color? textColor;
  final Color? borderColor;
  final Widget? rightIcon;

  const MaterialOutlinedButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.width = double.infinity,
    this.height = 48,
    this.enabled = true,
    this.loading = false,
    this.selected = false,
    this.textColor,
    this.borderColor,
    this.rightIcon,
  }) : super(key: key);

  bool isClickedRecently(DateTime? lastClickTime) {
    if (lastClickTime == null) return false;
    var now = DateTime.now();
    return (lastClickTime.difference(now).inMilliseconds) > -1000;
  }

  @override
  Widget build(BuildContext context) {
    DateTime? clickTime;

    final onButtonPressed = enabled
        ? () {
            if (loading) {
              return;
            } else if (isClickedRecently(clickTime)) {
              return;
            } else {
              clickTime = DateTime.now();
              onPressed.call();
            }
          }
        : null;

    final currentTextColor = textColor ?? context.textPrimary;
    var actualTextColor = enabled ? currentTextColor : currentTextColor.withAlpha((255 * 0.75).round());
    var currentBorderColor = borderColor ?? context.materialOutlinedButtonStroke;
    var actualBorderColor = enabled ? currentBorderColor : currentBorderColor.withAlpha((255 * 0.55).round());
    var actualTextAlign = rightIcon != null ? TextAlign.left : TextAlign.center;

    return OutlinedButton(
      onPressed: onButtonPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: context.materialOutlinedButtonBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        side: BorderSide(
          width: selected ? 1.5 : 1,
          color: actualBorderColor,
        ),
      ),
      child: SizedBox(
        width: width,
        height: height,
        child: Row(
          children: [
            Expanded(
              child: text.w(400).s(13).c(actualTextColor).copyWith(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: actualTextAlign,
                  ),
            ),
            Visibility(visible: loading, child: SizedBox(width: 12)),
            Visibility(
              visible: loading,
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: actualBorderColor,
                  strokeWidth: 1.5,
                  strokeAlign: 0.5,
                ),
              ),
            ),
            Visibility(visible: rightIcon != null, child: SizedBox(width: 12)),
            Visibility(
              visible: rightIcon != null,
              child: SizedBox(width: 24, height: 24, child: rightIcon),
            ),
          ],
        ),
      ),
    );
  }
}
