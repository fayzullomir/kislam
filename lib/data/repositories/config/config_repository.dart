import 'package:koreaislam/data/datasource/preference/auth_preferences.dart';
import 'package:koreaislam/data/datasource/preference/profile_preferences.dart';

class ConfigRepository {
  final AuthPreferences _authPreferences;
  final ProfilePreferences _profilePreferences;

  ConfigRepository(
    this._authPreferences,
    this._profilePreferences,
  );

  bool get isAuthorized => _authPreferences.isAuthorized;

  bool get isNotAuthorized => _authPreferences.isNotAuthorized;

  Stream<bool> get isAuthorizedStream => _authPreferences.isAuthorizedStream;
}
