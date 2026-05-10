part of 'permissions_cubit.dart';

@freezed
class PermissionsState with _$PermissionsState {
  const PermissionsState._();

  const factory PermissionsState({
    //
    @Default(0) int currentPageIndex,
    //
  }) = _PermissionsState;

  List<PermissionPageData> get permissions => [
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

  PermissionPageData get currentPermission => permissions[currentPageIndex];

  bool get isLastPermissionShown => currentPageIndex == permissions.length - 1;
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
