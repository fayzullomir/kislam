import 'package:flutter/material.dart';
import 'package:koreaislam/utils/screen/device_screen_type.dart';
import 'package:koreaislam/utils/screen/responsive_utils.dart';

/// Builds different widgets based on device screen type
/// Automatically detects device type - no manual breakpoints needed
class ResponsiveBuilder extends StatelessWidget {
  /// Widget to display on mobile devices (< 600dp)
  final Widget Function(BuildContext context) mobile;

  /// Widget to display on tablet devices (600-1024dp)
  /// If null, falls back to mobile widget
  final Widget Function(BuildContext context)? tablet;

  /// Widget to display on desktop devices (>= 1024dp)
  /// If null, falls back to tablet or mobile widget
  final Widget Function(BuildContext context)? desktop;

  /// Use screen width instead of constraints width
  /// Set to true when widget is inside Expanded/Flexible to get correct device type
  final bool useScreenWidth;

  const ResponsiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
    this.useScreenWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    if (useScreenWidth) {
      final deviceType = ResponsiveUtils.getDeviceTypeFromContext(context);

      return switch (deviceType) {
        DeviceScreenType.mobile => mobile(context),
        DeviceScreenType.tablet => tablet?.call(context) ?? mobile(context),
        DeviceScreenType.desktop =>
          desktop?.call(context) ?? tablet?.call(context) ?? mobile(context),
      };
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final deviceType =
            ResponsiveUtils.getDeviceTypeFromConstraints(constraints);

        return switch (deviceType) {
          DeviceScreenType.mobile => mobile(context),
          DeviceScreenType.tablet => tablet?.call(context) ?? mobile(context),
          DeviceScreenType.desktop =>
            desktop?.call(context) ?? tablet?.call(context) ?? mobile(context),
        };
      },
    );
  }
}
