part of 'chat_cubit.dart';

@freezed
class ChatState with _$ChatState {
  const ChatState._();

  @freezed
  const factory ChatState({
    @Default(LoadingState.loading) LoadingState pageState,
    String? url,
    DateTime? selectedDate,
  }) = _ChatState;


  DateTime get selectedDateOrToday => selectedDate ?? DateTime.now();
}

@freezed
class ChatEvent with _$ChatEvent {
  const factory ChatEvent() = _ChatEvent;
}
