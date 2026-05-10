import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionPageData {
  final Permission permission;
  final IconData icon;
  final String eyebrow;
  final String title;
  final String body;

  PermissionPageData({
    required this.permission,
    required this.icon,
    required this.eyebrow,
    required this.title,
    required this.body,
  });
}
