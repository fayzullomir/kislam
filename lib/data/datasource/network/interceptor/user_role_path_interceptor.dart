import 'package:dio/dio.dart';
import 'package:koreaislam/data/datasource/preference/profile_preferences.dart';

class UserRolePathInterceptor extends Interceptor {
  final ProfilePreferences _profilePreference;

  UserRolePathInterceptor(this._profilePreference);

  static const String placeholder = '{user_role_path}';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.path.contains(placeholder)) {
      final userRole = _profilePreference.userRole;
      options.path = options.path.replaceAll(placeholder, userRole.apiPath);
    }
    handler.next(options);
  }
}
