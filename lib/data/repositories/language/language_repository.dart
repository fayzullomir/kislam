import 'package:koreaislam/data/datasource/floor/dao/group_entity_dao.dart';
import 'package:koreaislam/data/datasource/preference/app_config_preferences.dart';
import 'package:koreaislam/domain/models/language/language.dart';

class LanguageRepository {
  final GroupEntityDao _categoryEntityDao;
  final AppConfigPreferences _appConfigPreferences;

  LanguageRepository(
    this._categoryEntityDao,
    this._appConfigPreferences,
  );

  Language getLanguage() {
    return _appConfigPreferences.language;
  }

  bool isLanguageSelected() {
    return _appConfigPreferences.isLanguageSelected;
  }

  Future<void> setLanguage(Language language) async {
    await _categoryEntityDao.clear();

    return _appConfigPreferences.setLanguage(language);
  }
}
