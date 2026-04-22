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
    _saveLanguage(Language.defaultLanguage);
  }

  void getLanguage() => _languageRepository.getLanguage();

  void setLanguage(Language language) {
    _saveLanguage(language);

    if (_appConfigPreferences.isIntroNotShown) {
      emitEvent(SetLanguageEvent(SetLanguageEventType.onOpenIntroPage));
    } else {
      emitEvent(SetLanguageEvent(SetLanguageEventType.onOpenLoginPage));
    }
  }

  Future<void> _saveLanguage(Language language) async {
    await _languageRepository.setLanguage(language);
  }
}
