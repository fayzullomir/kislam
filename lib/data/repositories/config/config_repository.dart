import 'package:koreaislam/data/datasource/preference/auth_preferences.dart';

class ConfigRepository {
  final AuthPreferences _authPreferences;

  ConfigRepository(this._authPreferences);

  bool get isAuthorized => _authPreferences.isAuthorized;

  bool get isNotAuthorized => _authPreferences.isNotAuthorized;

  Stream<bool> get isAuthorizedStream => _authPreferences.isAuthorizedStream;
}
