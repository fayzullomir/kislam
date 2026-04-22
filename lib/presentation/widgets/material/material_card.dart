import 'package:flutter/material.dart';
import 'package:koreaislam/presentation/support/extensions/color_extension.dart';

class MaterialCard extends StatelessWidget {
  final Widget child;
  final double elevation;
  final EdgeInsets margin;
  final EdgeInsets? padding;
  final BorderRadiusGeometry borderRadius;
  final Color? color;
  final double? height;
  final double? width;
  final List<BoxShadow>? boxShadow;

  const MaterialCard({
    super.key,
    required this.child,
    this.elevation = 0,
    this.margin = const EdgeInsets.all(1),
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.color,
    this.padding,
    this.height,
    this.width,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBoxShadow = boxShadow ??
        [
          BoxShadow(
            color: context.isDarkMode
                ? Colors.white.withOpacity(0.2)
                : Colors.black.withOpacity(0.15),
            blurRadius: elevation * 8,
            offset: Offset(0, elevation * 2),
          ),
        ];
    return Container(
      decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: color ?? context.customCardBackground,
          // color: color ?? context.cardColor,
          boxShadow: effectiveBoxShadow),
      padding: padding,
      margin: margin,
      height: height,
      width: width,
      child: child,
    );
  }
}
