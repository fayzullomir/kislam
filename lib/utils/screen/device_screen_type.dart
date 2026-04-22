enum DeviceScreenType {
  mobile,
  tablet,
  desktop;

  /// Check if current device is mobile
  bool get isMobile => this == DeviceScreenType.mobile;

  /// Check if current device is tablet
  bool get isTablet => this == DeviceScreenType.tablet;

  /// Check if current device is desktop
  bool get isDesktop => this == DeviceScreenType.desktop;
}
