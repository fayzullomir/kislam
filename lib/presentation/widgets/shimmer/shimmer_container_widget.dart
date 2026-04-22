import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:koreaislam/presentation/support/colors/static_colors.dart';
import 'package:koreaislam/presentation/widgets/material/material_card.dart';

class ShimmerContainerWidget extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final BorderRadiusGeometry borderRadius;

  const ShimmerContainerWidget({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.margin,
    this.padding,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
  });

  @override
  Widget build(BuildContext context) {
    return MaterialCard(
      width: width,
      height: height,
      margin: margin ?? const EdgeInsets.all(0),
      padding: padding,
      borderRadius: borderRadius,
      child: Shimmer.fromColors(
        baseColor: StaticColors.shimmerBaseColor,
        highlightColor: StaticColors.shimmerHighLightColor,
        child: child,
      ),
    );
  }
}
