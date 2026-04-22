import 'package:koreaislam/data/datasource/network/dto/notification/app_notification_response.dart';
import 'package:koreaislam/domain/models/notification/app_notification.dart';

extension AppNotificationResponseMapper on AppNotificationResponse {
  AppNotification toModel() {
    return AppNotification(
      id: id,
      senderId: senderId,
      senderType: senderType,
      receiverId: receiverId,
      receiverType: receiverType,
      title: title ?? "",
      body: body ?? "",
      data: data,
      typeIndex: typeIndex ?? 0,
      isSent: isSent ?? false,
      attemptCount: attemptCount ?? 0,
      isRead: isRead ?? false,
      createdAt: createdAt,
    );
  }
}
