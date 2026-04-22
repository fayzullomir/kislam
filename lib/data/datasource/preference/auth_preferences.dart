import 'package:koreaislam/data/datasource/preference/preferences_extensions.dart';
import 'package:injectable/injectable.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

@singleton
class AuthPreferences {
  final SharedPreferences _preferences;
  final RxSharedPreferences _rxPreferences;

  AuthPreferences(this._preferences, this._rxPreferences);

  static const String _keyAccessToken = "string_access_token";
  static const String _keyRefreshToken = "string_refresh_token";
  static const String _keyIsAuthorized = "bool_is_authorized";

  @FactoryMethod(preResolve: true)
  static Future<AuthPreferences> create() async {
    final preference = await SharedPreferences.getInstance();
    final rxPreference = RxSharedPreferences.getInstance();
    return AuthPreferences(preference, rxPreference);
  }

  // ==================== Streams ====================

  Stream<bool> get isAuthorizedStream =>
      _rxPreferences.getBoolStream(_keyIsAuthorized).map((v) => v ?? false);

  // ==================== Getters ====================

  String get accessToken => _preferences.getString(_keyAccessToken) ?? "";

  String get refreshToken => _preferences.getString(_keyRefreshToken) ?? "";

  bool get isAuthorized => _preferences.getBool(_keyIsAuthorized) ?? false;

  bool get isNotAuthorized => !isAuthorized;

  // ==================== Setters ====================

  Future<void> setAccessToken(String token) async =>
      await _preferences.setOrRemove(_keyAccessToken, token);

  Future<void> setRefreshToken(String? refreshToken) async =>
      await _preferences.setOrRemove(_keyRefreshToken, refreshToken);

  Future<void> setIsAuthorized(bool isAuthorized) async {
    await _preferences.setOrRemove(_keyIsAuthorized, isAuthorized);
    await _rxPreferences.setOrRemove(_keyIsAuthorized, isAuthorized);
  }

  Future<void> clear() async {
    await _preferences.remove(_keyAccessToken);
    await _preferences.remove(_keyRefreshToken);
    await _preferences.remove(_keyIsAuthorized);
    await _rxPreferences.remove(_keyIsAuthorized);
  }
}
