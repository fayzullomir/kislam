import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';

/// One step of the onboarding permission flow. The page is the same in
/// every case (eyebrow → title → body → primary CTA); the cubit decides
/// what the CTA actually does based on which optional field is set:
///
///   * [permission] — request a standard runtime permission.
///   * [customAction] — fall back to a non-standard side-effect (e.g.
///     opening the OEM-specific autostart settings page on Xiaomi /
///     Huawei / Oppo). When set, [permission] is ignored.
class PermissionPageData {
  final Permission? permission;
  final Future<void> Function()? customAction;
  final IconData icon;
  final String eyebrow;
  final String title;
  final String body;

  const PermissionPageData({
    this.permission,
    this.customAction,
    required this.icon,
    required this.eyebrow,
    required this.title,
    required this.body,
  }) : assert(
          permission != null || customAction != null,
          'PermissionPageData needs either a permission or a customAction',
        );
}
