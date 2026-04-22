import 'package:koreaislam/data/datasource/network/dto/notification/app_notification_response.dart';
import 'package:koreaislam/data/datasource/network/services/notification_service.dart';
import 'package:koreaislam/data/datasource/preference/auth_preferences.dart';
import 'package:koreaislam/data/datasource/preference/fcm_token_preferences.dart';
import 'package:koreaislam/data/datasource/preference/temporarily_data_holder.dart';
import 'package:koreaislam/data/mappers/app_notification_mappers.dart';
import 'package:koreaislam/domain/models/notification/app_notification.dart';

class NotificationRepository {
  final AuthPreferences _authPreferences;
  final FcmTokenPreferences _fcmTokenPreferences;
  final NotificationService _notificationService;

  NotificationRepository(
    this._authPreferences,
    this._fcmTokenPreferences,
    this._notificationService,
  );

  Future<void> activateFcmToken() async {
    if (_authPreferences.isNotAuthorized) {
      return;
    }
    await _notificationService.activateFcmToken(_fcmTokenPreferences.fcmToken);
    await _fcmTokenPreferences.setIsFcmTokenSent(true);
    return;
  }

  Future<void> deactivateFcmToken() async {
    await _notificationService.deactivateFcmToken();
    TemporarilyDataHolder.clearTokenValues();
    _fcmTokenPreferences.clear();

    return;
  }

  Future<List<AppNotification>> fetchAppNotifications({
    required int page,
    required int size,
  }) async {
    var response = await _notificationService.fetchAppNotifications(
      page: page,
      size: size,
    );
    var rootResponse = AppNotificationRootResponse.fromJson(response.data);
    return rootResponse.notifications?.map((e) => e.toModel()).toList() ?? [];
  }
}
