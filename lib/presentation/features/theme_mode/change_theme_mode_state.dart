part of 'change_theme_mode_cubit.dart';

@freezed
class ChangeThemeModeState with _$ChangeThemeModeState {
  const factory ChangeThemeModeState({
//
    AppThemeMode? appThemeMode,
//
  }) = _ChangeThemeModeState;
}

@freezed
class ChangeThemeModeEvent with _$ChangeThemeModeEvent {
  const factory ChangeThemeModeEvent() = _ChangeThemeModeEvent;
}
