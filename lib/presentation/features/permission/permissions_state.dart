part of 'permissions_cubit.dart';

@freezed
class PermissionsState with _$PermissionsState {
  const PermissionsState._();

  const factory PermissionsState({
    //
    @Default(0) int currentPageIndex,
    //
    @Default(false) bool isAutoStartAvailable,
    //
  }) = _PermissionsState;

  /// Onboarding permission steps. The notification + location pair is
  /// shown on every platform; the battery-optimization and OEM-autostart
  /// steps are Android-only because their underlying APIs don't exist
  /// on iOS. The autostart step is only included when the device's OEM
  /// actually exposes an autostart settings page ([isAutoStartAvailable],
  /// resolved by the cubit); on stock Android and unsupported brands the
  /// step is skipped entirely so the user never sees a dead-end screen.
  List<PermissionPageData> get permissions {
    final base = <PermissionPageData>[
      PermissionPageData(
        permission: Permission.notification,
        icon: Icons.notifications_none_rounded,
        eyebrow: Strings.permissionNotificationEyebrow,
        title: Strings.permissionNotificationTitle,
        body: Strings.permissionNotificationBody,
      ),
      PermissionPageData(
        permission: Permission.locationWhenInUse,
        icon: Icons.place_outlined,
        eyebrow: Strings.permissionLocationEyebrow,
        title: Strings.permissionLocationTitle,
        body: Strings.permissionLocationBody,
      ),
    ];
    if (Platform.isAndroid) {
      base.add(
        PermissionPageData(
          permission: Permission.ignoreBatteryOptimizations,
          icon: Icons.battery_charging_full_rounded,
          eyebrow: Strings.permissionBatteryEyebrow,
          title: Strings.permissionBatteryTitle,
          body: Strings.permissionBatteryBody,
        ),
      );
      if (this.isAutoStartAvailable) {
        base.add(
          PermissionPageData(
            customAction: _openAutoStartSettings,
            icon: Icons.power_settings_new_rounded,
            eyebrow: Strings.permissionAutostartEyebrow,
            title: Strings.permissionAutostartTitle,
            body: Strings.permissionAutostartBody,
          ),
        );
      }
    }
    return base;
  }

  PermissionPageData get currentPermission => permissions[currentPageIndex];

  bool get isLastPermissionShown => currentPageIndex == permissions.length - 1;
}

/// Opens the OEM-specific "auto-start" settings page. Only reached on
/// devices where the plugin reported `isAutoStartAvailable = true`
/// (Xiaomi, Huawei, Oppo, Vivo, Honor, Letv, Asus); on other brands the
/// step isn't added to the flow at all.
Future<void> _openAutoStartSettings() async {
  try {
    await getAutoStartPermission();
  } catch (e, s) {
    AppLog.e('❌ openAutoStartSettings failed', error: e, stackTrace: s);
  }
}

@freezed
class PermissionsEvent with _$PermissionsEvent {
  const factory PermissionsEvent(PermissionsEventType type) = _PermissionsEvent;
}

enum PermissionsEventType {
  onOpenNextPermission,
  onOpenSystemSettings,
  onOpenLoginPage,
}
