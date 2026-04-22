import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:koreaislam/presentation/support/extensions/color_extension.dart';

class CustomToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String negativeTitle;
  final String positiveTitle;
  final int maxLines;
  final EdgeInsets padding;
  final double borderRadius;
  final Duration animationDuration;

  const CustomToggle({
    super.key,
    required this.value,
    required this.onChanged,
    required this.negativeTitle,
    required this.positiveTitle,
    this.maxLines = 3,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    this.borderRadius = 14,
    this.animationDuration = const Duration(milliseconds: 250),
  });

  @override
  Widget build(BuildContext context) {
    final radius = Radius.circular(borderRadius);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _buildOption(
              context: context,
              title: negativeTitle,
              selected: !value,
              borderRadius: BorderRadius.only(
                topLeft: radius,
                bottomLeft: radius,
              ),
              isLeft: true,
              onTap: () => _onTap(false),
            ),
          ),
          Expanded(
            child: _buildOption(
              context: context,
              title: positiveTitle,
              selected: value,
              borderRadius: BorderRadius.only(
                topRight: radius,
                bottomRight: radius,
              ),
              isLeft: false,
              onTap: () => _onTap(true),
            ),
          ),
        ],
      ),
    );
  }

  void _onTap(bool newValue) {
    if (value != newValue) {
      onChanged(newValue);
      HapticFeedback.selectionClick();
    }
  }

  Widget _buildOption({
    required BuildContext context,
    required String title,
    required bool selected,
    required BorderRadius borderRadius,
    required bool isLeft,
    required VoidCallback onTap,
  }) {
    final borderColor =
        selected ? context.inputStrokeActiveColor : context.inputStrokeColor;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: animationDuration,
        curve: Curves.easeInOut,
        padding: padding,
        decoration: BoxDecoration(
          color: selected
              ? context.inputStrokeActiveColor.withOpacity(0.1)
              : context.inputBackgroundColor,
          borderRadius: borderRadius,
          border: Border(
            top: BorderSide(width: 1.5, color: borderColor),
            bottom: BorderSide(width: 1.5, color: borderColor),
            left: BorderSide(
              width: 1.5,
              color: borderColor,
            ),
            right: BorderSide(
              width: isLeft ? 0.75 : 1.5,
              color: borderColor,
            ),
          ),
        ),
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: animationDuration,
            curve: Curves.easeInOut,
            style: TextStyle(
              color: selected
                  ? context.inputStrokeActiveColor
                  : context.textSecondary,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            child: Text(
              title,
              textAlign: TextAlign.center,
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}
