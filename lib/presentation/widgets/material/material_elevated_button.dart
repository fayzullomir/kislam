import 'package:flutter/material.dart';
import 'package:koreaislam/core/extensions/text_extensions.dart';
import 'package:koreaislam/presentation/support/extensions/color_extension.dart';

class MaterialElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double width;
  final double height;
  final bool loading;
  final bool enabled;
  final Color? textColor;
  final double textSize;
  final Color? backgroundColor;
  final Widget? leftIcon;
  final Widget? rightIcon;

  const MaterialElevatedButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.width = double.infinity,
    this.height = 48,
    this.enabled = true,
    this.loading = false,
    this.textColor,
    this.textSize = 15,
    this.backgroundColor,
    this.leftIcon,
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
              onPressed?.call();
            }
          }
        : null;

    var actualTextColor = textColor != null
        ? (enabled ? textColor! : textColor!.withAlpha((255 * 0.75).round()))
        : Colors.white;
    var backcolor = backgroundColor ?? context.materialElevatedButtonBackground;
    var actualBackgroundColor =
        enabled ? backcolor : backcolor.withAlpha((255 * 0.75).round());
    var actualTextAlign = rightIcon != null ? TextAlign.left : TextAlign.center;

    final hasIcon = leftIcon != null || rightIcon != null;

    return InkWell(
      onTap: onButtonPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: actualBackgroundColor,
        ),
        child: Row(
          children: [
            Visibility(
              visible: hasIcon || loading,
              child: SizedBox(
                width: 20,
                height: 20,
                child: leftIcon ?? SizedBox(width: 20),
              ),
            ),
            Expanded(
              child: text.w(500).s(textSize).c(actualTextColor).copyWith(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: actualTextAlign,
                  ),
            ),
            Visibility(
              visible: hasIcon || loading,
              child: SizedBox(
                width: 20,
                height: 20,
                child: loading
                    ? CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 1.5,
                        strokeAlign: 0.5,
                      )
                    : SizedBox(width: 20),
              ),
            ),
            Visibility(
              visible: hasIcon,
              child: SizedBox(width: 12),
            ),
            Visibility(
              visible: hasIcon,
              child: SizedBox(
                width: 20,
                height: 20,
                child: rightIcon,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
