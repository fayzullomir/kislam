part of 'permissions_cubit.dart';

@freezed
class PermissionsState with _$PermissionsState {
  const PermissionsState._();

  const factory PermissionsState({
    //
    @Default(0) int currentPageIndex,
    //
  }) = _PermissionsState;

  /// Onboarding permission steps. The notification + location pair is
  /// shown on every platform; the battery-optimization and OEM-autostart
  /// steps are Android-only because their underlying APIs don't exist
  /// on iOS. We always include the autostart step on Android — the
  /// `auto_start_flutter` plugin internally falls back to a no-op /
  /// generic app-info screen when the OEM isn't supported.
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
      base.addAll([
        PermissionPageData(
          permission: Permission.ignoreBatteryOptimizations,
          icon: Icons.battery_charging_full_rounded,
          eyebrow: Strings.permissionBatteryEyebrow,
          title: Strings.permissionBatteryTitle,
          body: Strings.permissionBatteryBody,
        ),
        PermissionPageData(
          customAction: _openAutoStartSettings,
          icon: Icons.power_settings_new_rounded,
          eyebrow: Strings.permissionAutostartEyebrow,
          title: Strings.permissionAutostartTitle,
          body: Strings.permissionAutostartBody,
        ),
      ]);
    }
    return base;
  }

  PermissionPageData get currentPermission => permissions[currentPageIndex];

  bool get isLastPermissionShown => currentPageIndex == permissions.length - 1;
}

/// Opens the OEM-specific "auto-start" settings page when available
/// (Xiaomi, Huawei, Oppo, Vivo, Honor, Letv, Asus). On other devices
/// the plugin reports `isAutoStartAvailable = false` and we silently
/// move on — there's nothing for the user to toggle there.
Future<void> _openAutoStartSettings() async {
  try {
    final available = await isAutoStartAvailable;
    if (available == true) {
      await getAutoStartPermission();
    }
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
