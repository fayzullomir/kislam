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
          image: Assets.images.intro.permissionNotification,
          title: Strings.permissionNotificationTitle,
          message: Strings.permissionNotificationMessage,
        ),
        PermissionPageData(
          permission: Permission.locationWhenInUse,
          image: Assets.images.intro.permissionLocation,
          title: Strings.permissionLocationTitle,
          message: Strings.permissionLocationMessage,
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
