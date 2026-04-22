import 'package:flutter/material.dart';
import 'package:koreaislam/presentation/support/extensions/color_extension.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({
    super.key,
    this.height,
    this.thickness,
    this.startIndent,
    this.endIndent,
    this.color,
  });

  final double? height;
  final double? thickness;
  final double? startIndent;
  final double? endIndent;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: height ?? 0,
      thickness: thickness,
      indent: startIndent ?? 0,
      endIndent: endIndent ?? 0,
      color: context.colorDivider,
    );
  }
}
