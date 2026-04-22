part of 'change_language_cubit.dart';

@freezed
class ChangeLanguageState with _$ChangeLanguageState {
  const factory ChangeLanguageState({
//
    Language? selectedLanguage,
//
  }) = _ChangeLanguageState;
}

@freezed
class ChangeLanguageEvent with _$ChangeLanguageEvent {
  const factory ChangeLanguageEvent() = _ChangeLanguageEvent;
}
