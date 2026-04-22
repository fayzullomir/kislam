part of 'main_cubit.dart';

@freezed
class MainState with _$MainState {
  const MainState._();

  const factory MainState({
    @Default(0) int notificationCount,
    @Default(56) double bottomNavHeight,
  }) = _MainState;
}

@freezed
class MainEvent with _$MainEvent {
  const factory MainEvent() = _MainEvent;
}
