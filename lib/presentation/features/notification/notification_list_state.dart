part of 'notification_list_cubit.dart';

@freezed
class NotificationListState with _$NotificationListState {
  const NotificationListState._();

  const factory NotificationListState({
    @Default(null) PagingController<int, AppNotification>? controller,
  }) = _NotificationListState;
}

@freezed
class NotificationListEvent with _$NotificationListEvent {
  const factory NotificationListEvent(NotificationListEventType type) = _NotificationListEvent;
}

enum NotificationListEventType { onLanguageSet }