import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:koreaislam/data/datasource/preference/app_config_preferences.dart';
import 'package:koreaislam/data/repositories/language/language_repository.dart';
import 'package:koreaislam/domain/models/language/language.dart';
import 'package:koreaislam/presentation/support/cubit/base_cubit.dart';

part 'set_language_cubit.freezed.dart';
part 'set_language_state.dart';

@injectable
class SetLanguageCubit extends BaseCubit<SetLanguageState, SetLanguageEvent> {
  final AppConfigPreferences _appConfigPreferences;
  final LanguageRepository _languageRepository;

  SetLanguageCubit(
    this._appConfigPreferences,
    this._languageRepository,
  ) : super(const SetLanguageState()) {
    // Pre-select the device language when it's supported so the picker
    // opens already highlighting the user's system language. Falls back
    // to the default when the device locale isn't one of the app's
    // languages, or to the previously saved language if any.
    final initial = _appConfigPreferences.isLanguageSelected
        ? _appConfigPreferences.language
        : Language.fromDeviceLocale();
    updateState((state) => state.copyWith(language: initial));
    _saveLanguage(initial);
  }

  void getLanguage() => _languageRepository.getLanguage();

  /// Updates the in-memory selection without persisting it. The page calls
  /// this on row tap so the checkmark moves while the user previews; the
  /// final commit happens in [confirm].
  void setSelected(Language language) {
    updateState((state) => state.copyWith(language: language));
  }

  /// Persists the currently-selected language and emits the navigation
  /// event for whichever screen comes next.
  void confirm() {
    final language = states.language;
    _saveLanguage(language);

    if (_appConfigPreferences.isPermissionsNotShown) {
      emitEvent(SetLanguageEvent(SetLanguageEventType.onOpenPermissionsPage));
    } else {
      emitEvent(SetLanguageEvent(SetLanguageEventType.onOpenLoginPage));
    }
  }

  Future<void> _saveLanguage(Language language) async {
    await _languageRepository.setLanguage(language);
  }
}
