import 'package:injectable/injectable.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';
import 'package:koreaislam/data/datasource/preference/preferences_extensions.dart';
import 'package:koreaislam/domain/models/user/user_role.dart';

@singleton
class ProfilePreferences {
  final SharedPreferences _preferences;
  final RxSharedPreferences _rxPreferences;

  ProfilePreferences(this._preferences, this._rxPreferences);

  @FactoryMethod(preResolve: true)
  static Future<ProfilePreferences> create() async {
    final preference = await SharedPreferences.getInstance();
    final rxPreference = RxSharedPreferences.getInstance();
    return ProfilePreferences(preference, rxPreference);
  }

  /// User Info Keys
  static const _keyUserId = "integer_user_id";
  static const _keyUserFirstName = "string_user_first_name";
  static const _keyUserLastName = "string_user_last_name";
  static const _keyUserEmail = "string_user_email";
  static const _keyUserPhoneNumber = "string_user_phone_number";
  static const _keyUserPhoto = "string_user_photo";
  static const _keyUserRole = "string_user_role";
  static const _keyUserSessionId = "string_user_session_id";
  static const _keyUserPersonalId = "string_user_personal_id";

  // ==================== User Profile Streams ====================

  Stream<String> get firstNameStream =>
      _rxPreferences.getStringStream(_keyUserFirstName).map((v) => v ?? "");

  Stream<String> get lastNameStream =>
      _rxPreferences.getStringStream(_keyUserLastName).map((v) => v ?? "");

  Stream<String> get phoneNumberStream =>
      _rxPreferences.getStringStream(_keyUserPhoneNumber).map((v) => v ?? "");

  Stream<String> get profilePhotoStream =>
      _rxPreferences.getStringStream(_keyUserPhoto).map((v) => v ?? "");

  // ==================== User Info Getters ====================

  bool get isIdentified => userId != -1;

  bool get isNotIdentified => !isIdentified;

  int get userId => _preferences.getInt(_keyUserId) ?? -1;

  String get firstName => _preferences.getString(_keyUserFirstName) ?? "";

  String get lastName => _preferences.getString(_keyUserLastName) ?? "";

  String get email => _preferences.getString(_keyUserEmail) ?? "";

  String get phoneNumber => _preferences.getString(_keyUserPhoneNumber) ?? "";

  String get profilePhotoUrl => _preferences.getString(_keyUserPhoto) ?? "";

  String get sessionId => _preferences.getString(_keyUserSessionId) ?? "";

  String get personalId => _preferences.getString(_keyUserPersonalId) ?? "";

  UserRole get userRole =>
      UserRole.valueOrDefault(_preferences.getString(_keyUserRole));

  // ==================== Setters ====================

  Future<void> setUserProfile({
    required int id,
    required String firstName,
    required String lastName,
    required String? email,
    required String phoneNumber,
    required UserRole userRole,
    required String? personalId,
    required String sessionId,
    required String? profilePhoto,
  }) async {
    await _rxPreferences.setOrRemove(_keyUserFirstName, firstName);
    await _rxPreferences.setOrRemove(_keyUserLastName, lastName);
    await _rxPreferences.setOrRemove(_keyUserPhoneNumber, phoneNumber);
    await _rxPreferences.setOrRemove(_keyUserPhoto, profilePhoto);

    await _preferences.setOrRemove(_keyUserId, id);
    await _preferences.setOrRemove(_keyUserFirstName, firstName);
    await _preferences.setOrRemove(_keyUserLastName, lastName);
    await _preferences.setOrRemove(_keyUserEmail, email);
    await _preferences.setOrRemove(_keyUserPhoneNumber, phoneNumber);
    await _preferences.setOrRemove(_keyUserRole, userRole.name);
    await _preferences.setOrRemove(_keyUserPersonalId, personalId);
    await _preferences.setOrRemove(_keyUserSessionId, sessionId);
    await _preferences.setOrRemove(_keyUserPhoto, profilePhoto);
  }

  Future<void> updateUserProfile({
    required String firstName,
    required String lastName,
    required String? photoUrl,
  }) async {
    await _preferences.setOrRemove(_keyUserFirstName, firstName);
    await _preferences.setOrRemove(_keyUserLastName, lastName);
    await _preferences.setOrRemove(_keyUserPhoto, photoUrl ?? profilePhotoUrl);

    await _rxPreferences.setOrRemove(_keyUserFirstName, firstName);
    await _rxPreferences.setOrRemove(_keyUserLastName, lastName);
    await _rxPreferences.setOrRemove(_keyUserPhoto, photoUrl ?? profilePhotoUrl);
  }

  Future<void> clearUserProfile() async {
    await _preferences.remove(_keyUserId);
    await _preferences.remove(_keyUserFirstName);
    await _preferences.remove(_keyUserLastName);
    await _preferences.remove(_keyUserEmail);
    await _preferences.remove(_keyUserPhoneNumber);
    await _preferences.remove(_keyUserPhoto);
    await _preferences.remove(_keyUserRole);
    await _preferences.remove(_keyUserSessionId);
    await _preferences.remove(_keyUserPersonalId);

    await _rxPreferences.remove(_keyUserFirstName);
    await _rxPreferences.remove(_keyUserLastName);
    await _rxPreferences.remove(_keyUserPhoneNumber);
    await _rxPreferences.remove(_keyUserPhoto);
  }

  Future<void> clear() async {
    await clearUserProfile();
  }
}
