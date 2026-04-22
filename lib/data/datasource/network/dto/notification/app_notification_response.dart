// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_notification_response.freezed.dart';
part 'app_notification_response.g.dart';

@freezed
class AppNotificationRootResponse with _$AppNotificationRootResponse {
  const factory AppNotificationRootResponse({
    @JsonKey(name: 'items') List<AppNotificationResponse>? notifications,
    @JsonKey(name: 'total') int? total,
    @JsonKey(name: 'page') int? page,
    @JsonKey(name: 'size') int? size,
    @JsonKey(name: 'pages') int? pages,
  }) = _AppNotificationRootResponse;

  factory AppNotificationRootResponse.fromJson(Map<String, dynamic> json) =>
      _$AppNotificationRootResponseFromJson(json);
}

@freezed
class AppNotificationResponse with _$AppNotificationResponse {
  const factory AppNotificationResponse({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'sender_id') int? senderId,
    @JsonKey(name: 'sender_type') String? senderType,
    @JsonKey(name: 'receiver_id') int? receiverId,
    @JsonKey(name: 'receiver_type') String? receiverType,
    @JsonKey(name: 'title')  String? title,
    @JsonKey(name: 'body')  String? body,
    @JsonKey(name: 'data') Map<String, dynamic>? data,
    @JsonKey(name: 'type_index') int? typeIndex,
    @JsonKey(name: 'is_sent') bool? isSent,
    @JsonKey(name: 'attempt_count') int? attemptCount,
    @JsonKey(name: 'is_read') bool? isRead,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _AppNotificationResponse;

  factory AppNotificationResponse.fromJson(Map<String, dynamic> json) =>
      _$AppNotificationResponseFromJson(json);
}
