import 'package:flutter/material.dart';
import 'package:koreaislam/utils/screen/device_screen_type.dart';
import 'package:koreaislam/utils/screen/responsive_utils.dart';

/// Container that automatically adapts its max width based on device type
class ResponsiveContainer extends StatelessWidget {
  final Widget child;

  /// Max width for mobile devices (null = full width)
  final double? mobileMaxWidth;

  /// Max width for tablet devices (null = full width)
  /// Default: 600
  final double? tabletMaxWidth;

  /// Max width for desktop devices (null = full width)
  /// Default: 1200
  final double? desktopMaxWidth;

  /// Alignment of the container
  final Alignment alignment;

  /// Padding around the container
  final EdgeInsetsGeometry? padding;

  /// Margin around the container
  final EdgeInsetsGeometry? margin;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.mobileMaxWidth,
    this.tabletMaxWidth = 420,
    this.desktopMaxWidth = 420,
    this.alignment = Alignment.center,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final deviceType =
            ResponsiveUtils.getDeviceTypeFromConstraints(constraints);

        // Determine effective width based on device type
        final double? effectiveWidth = switch (deviceType) {
          DeviceScreenType.mobile => mobileMaxWidth,
          DeviceScreenType.tablet => tabletMaxWidth,
          DeviceScreenType.desktop => desktopMaxWidth,
        };

        Widget content = SizedBox(
          width: effectiveWidth,
          child: child,
        );

        // Apply padding if provided
        if (padding != null) {
          content = Padding(
            padding: padding!,
            child: content,
          );
        }

        // Apply margin if provided
        if (margin != null) {
          content = Padding(
            padding: margin!,
            child: content,
          );
        }

        return Align(
          alignment: alignment,
          child: content,
        );
      },
    );
  }
}
