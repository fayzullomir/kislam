import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:koreaislam/data/datasource/preference/preferences_extensions.dart';
import 'package:koreaislam/domain/models/language/language.dart';

class AppConfigPreferences {
  final SharedPreferences _preferences;

  AppConfigPreferences(this._preferences);

  static const String _keyIsOnboardingShown = "bool_is_onboarding_shown";

  static const String _keyIsMadhabSelected = "bool_is_madhab_selected";

  static const String _keyLanguage = "string_language";

  @factoryMethod
  static Future<AppConfigPreferences> create() async {
    final prefs = await SharedPreferences.getInstance();
    return AppConfigPreferences(prefs);
  }

  bool get isOnboardingShown =>
      _preferences.getBool(_keyIsOnboardingShown) ?? false;

  bool get isOnboardingNotShown => !isOnboardingShown;

  bool get isMadhabSelected =>
      _preferences.getBool(_keyIsMadhabSelected) ?? false;

  bool get isMadhabNotSelected => !isMadhabSelected;

  bool get isLanguageSelected => _preferences.containsKey(_keyLanguage);

  bool get isLanguageNotSelected => !isLanguageSelected;

  Language get language =>
      Language.valueOrDefault(_preferences.getString(_keyLanguage));

  Future<void> setIsOnboardingShown(bool isOnboardingShown) async =>
      await _preferences.setOrRemove(_keyIsOnboardingShown, isOnboardingShown);

  Future<void> setIsMadhabSelected(bool isMadhabSelected) async =>
      await _preferences.setOrRemove(_keyIsMadhabSelected, isMadhabSelected);

  Future<void> setLanguage(Language language) async =>
      await _preferences.setOrRemove(_keyLanguage, language.name);

  Future<void> clear() async {
    // await _preferences.remove(_keyIsOnboardingShown);
    // await _preferences.remove(_keyLanguage);
  }
}
