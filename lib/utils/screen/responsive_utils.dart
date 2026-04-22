import 'package:flutter/widgets.dart';
import 'package:koreaislam/utils/screen/device_screen_type.dart';

class ResponsiveUtils {
  ResponsiveUtils._(); // private constructor

  static const double mobileMaxWidth = 600;
  static const double tabletMaxWidth = 1024;
  static const double watchMaxWidth = 300;

  /// Get device screen type from width
  static DeviceScreenType getDeviceType(double width) {
    if (width < mobileMaxWidth) {
      return DeviceScreenType.mobile;
    } else if (width < tabletMaxWidth) {
      return DeviceScreenType.tablet;
    } else {
      return DeviceScreenType.desktop;
    }
  }

  /// Get device screen type from BuildContext
  static DeviceScreenType getDeviceTypeFromContext(BuildContext context) {
    return getDeviceType(MediaQuery.of(context).size.width);
  }

  /// Get device screen type from LayoutBuilder constraints
  static DeviceScreenType getDeviceTypeFromConstraints(
    BoxConstraints constraints,
  ) {
    return getDeviceType(constraints.maxWidth);
  }
}
