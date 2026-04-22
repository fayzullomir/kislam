import 'package:dio/dio.dart';

class NotificationService {
  final Dio bearerDio;
  final Dio cachedDio;

  NotificationService({
    required this.bearerDio,
    required this.cachedDio,
  });

  Future<Response> activateFcmToken(String fcmToken) {
    final queryParams = {"token": fcmToken};
    return bearerDio.put('mobile/auth/fcm-token/register',
        queryParameters: queryParams);
  }

  Future<Response> fetchAppNotifications({
    required int page,
    required int size,
  }) {
    final queryParams = {
      "page": page,
      "size": size,
    };
    return bearerDio.get(
      "mobile/auth/notification/all",
      queryParameters: queryParams,
    );
  }

  Future<Response> deactivateFcmToken() {
    return cachedDio.put(
      'mobile/auth/fcm-token/deactivate',
    );
  }
}
