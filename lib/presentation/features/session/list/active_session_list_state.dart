part of 'active_session_list_cubit.dart';

@freezed
class ActiveSessionListState with _$ActiveSessionListState {
  const ActiveSessionListState._();

  const factory ActiveSessionListState({
    @Default(null) PagingController<int, ActiveSession>? controller,
    ActiveSession? terminatingSession,
  }) = _ActiveSessionListState;
}

@freezed
class ActiveSessionListEvent with _$ActiveSessionListEvent {
  const factory ActiveSessionListEvent(ActiveSessionListEventType type) = _ActiveSessionListEvent;
}

sealed class ActiveSessionListEventType {}

class OnSessionTerminated extends ActiveSessionListEventType {
  final int sessionId;

  OnSessionTerminated({required this.sessionId});
}
