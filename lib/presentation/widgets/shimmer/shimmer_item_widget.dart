import 'package:flutter/material.dart';
import 'package:koreaislam/presentation/support/colors/static_colors.dart';

class ShimmerItemWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margin;
  final BorderRadius borderRadius;

  const ShimmerItemWidget({
    super.key,
    this.width,
    this.height,
    this.margin,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.maxFinite,
      height: height,
      margin: margin ?? const EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: StaticColors.shimmerBaseColor,
        borderRadius: borderRadius,
      ),
    );
  }
}
