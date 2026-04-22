import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:koreaislam/data/datasource/preference/preferences_extensions.dart';
import 'package:koreaislam/domain/models/language/language.dart';

class AppConfigPreferences {
  final SharedPreferences _preferences;

  AppConfigPreferences(this._preferences);

  static const String _keyIsIntroShown = "bool_is_intro_shown";

  static const String _keyLanguage = "string_language";

  @factoryMethod
  static Future<AppConfigPreferences> create() async {
    final prefs = await SharedPreferences.getInstance();
    return AppConfigPreferences(prefs);
  }

  bool get isIntroShown => _preferences.getBool(_keyIsIntroShown) ?? false;

  bool get isIntroNotShown => !isIntroShown;

  bool get isLanguageSelected => _preferences.containsKey(_keyLanguage);

  bool get isLanguageNotSelected => !isLanguageSelected;

  Language get language =>
      Language.valueOrDefault(_preferences.getString(_keyLanguage));

  Future<void> setIsIntroShown(bool isIntroShown) async =>
      await _preferences.setOrRemove(_keyIsIntroShown, isIntroShown);

  Future<void> setLanguage(Language language) async =>
      await _preferences.setOrRemove(_keyLanguage, language.name);

  Future<void> clear() async {
    // await _preferences.remove(_keyIsIntroShown);
    // await _preferences.remove(_keyLanguage);
  }
}
