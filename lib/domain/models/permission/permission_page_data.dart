import 'package:permission_handler/permission_handler.dart';
import 'package:koreaislam/core/gen/assets/assets.gen.dart';

class PermissionPageData {
  final Permission permission;
  final SvgGenImage image;
  final String title;
  final String message;

  PermissionPageData({
    required this.permission,
    required this.image,
    required this.title,
    required this.message,
  });
}
