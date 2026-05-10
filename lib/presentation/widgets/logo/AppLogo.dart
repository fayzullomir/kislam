import 'package:flutter/material.dart';
import 'package:koreaislam/core/gen/assets/assets.gen.dart';

class AppLogo extends StatelessWidget {
  final double size;

  const AppLogo({super.key, this.size = 64});

  @override
  Widget build(BuildContext context) {
    var isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ClipOval(
      child: (isDarkMode
              ? Assets.images.logo.appLogoLogo
              : Assets.images.logo.appLogoLogo)
          .image(height: size, width: size, fit: BoxFit.cover),
    );
  }
}
