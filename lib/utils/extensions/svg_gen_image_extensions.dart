import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:koreaislam/core/gen/assets/assets.gen.dart';

extension SvgGenImageColor on SvgGenImage {
  SvgPicture svg({
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    Alignment alignment = Alignment.center,
    Color? color,
  }) {
    return this.svg(
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      colorFilter: color != null
          ? ColorFilter.mode(
              color,
              BlendMode.srcIn,
            )
          : null,
    );
  }
}
