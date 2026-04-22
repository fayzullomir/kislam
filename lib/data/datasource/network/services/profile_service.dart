import 'package:dio/dio.dart';

class ProfileService {
  final Dio _dio;

  ProfileService(this._dio);

  Future<Response> fetchProfile() {
    return _dio.get("mobile/{user_role_path}/");
  }

  Future<Response> updateProfile({
    required String firstName,
    required String lastName,
    required String? profilePhotoUrl,
  }) {
    final body = {
      "first_name": firstName,
      "last_name": lastName,
      if (profilePhotoUrl != null && profilePhotoUrl.isNotEmpty)
        "profile_photo": profilePhotoUrl,
    };
    return _dio.put("mobile/{user_role_path}/", data: body);
  }
}
