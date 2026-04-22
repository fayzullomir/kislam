import 'package:auto_route/auto_route.dart';
import 'package:koreaislam/domain/models/user/user_role.dart';
import 'package:koreaislam/presentation/router/app_router.dart';

extension UserRoleRouterExtension on UserRole {
  PageRouteInfo<dynamic> get homePage {
    switch (this) {
      case UserRole.user:
      case UserRole.unknown:
        return const MainRoute();
    }
  }
}
