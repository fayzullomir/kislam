import 'package:koreaislam/core/log/logger/app_log.dart';
import 'package:koreaislam/data/datasource/network/dto/profile/profile_response.dart';
import 'package:koreaislam/data/datasource/network/services/profile_service.dart';
import 'package:koreaislam/data/datasource/preference/profile_preferences.dart';
import 'package:koreaislam/domain/models/user/user.dart';

class ProfileRepository {
  final ProfileService _profileService;
  final ProfilePreferences _profilePreferences;

  ProfileRepository(
    this._profileService,
    this._profilePreferences,
  );

  /// User Info

  int get userId => _profilePreferences.userId;

  String get userFirstName => _profilePreferences.firstName;

  String get userLastName => _profilePreferences.lastName;

  String get userPhoneNumber => _profilePreferences.phoneNumber;

  String get profilePhotoUrl => _profilePreferences.profilePhotoUrl;

  Stream<String> get firstNameStream => _profilePreferences.firstNameStream;

  Stream<String> get lastNameStream => _profilePreferences.lastNameStream;

  Stream<String> get phoneNumberStream => _profilePreferences.phoneNumberStream;

  Stream<String> get profilePhotoStream => _profilePreferences.profilePhotoStream;

  Future<User?> readUser() async {
    return null;
  }

  Future<void> fetchProfile() async {
    var response = await _profileService.fetchProfile();

    AppLog.e("fetchProfile Profile Response: ${response.data}");

    final profileResponse = ProfileResponse.fromJson(response.data);

    AppLog.e("fetchProfile Parsed Profile Response: $profileResponse");

    String actualPhoneNumber = profileResponse.phoneNumber ?? "";
    if (actualPhoneNumber.isEmpty) {
      actualPhoneNumber = _profilePreferences.phoneNumber;
    }

    await _profilePreferences.setUserProfile(
      id: profileResponse.userId,
      firstName: profileResponse.firstName ?? "",
      lastName: profileResponse.lastName ?? "",
      phoneNumber: actualPhoneNumber,
      userRole: _profilePreferences.userRole,
      email: profileResponse.email ?? "",
      personalId: profileResponse.personalId ?? "",
      sessionId: profileResponse.sessionId ?? "",
      profilePhoto: profileResponse.profilePhoto ?? "",
    );
    return;
  }

  Future<void> updateProfile({
    required String firstName,
    required String lastName,
    required String? profilePhotoUrl,
  }) async {
    await _profileService.updateProfile(
      firstName: firstName,
      lastName: lastName,
      profilePhotoUrl: profilePhotoUrl,
    );

    await _profilePreferences.setUserProfile(
      id: _profilePreferences.userId,
      firstName: firstName,
      lastName: lastName,
      phoneNumber: _profilePreferences.phoneNumber,
      userRole: _profilePreferences.userRole,
      email: _profilePreferences.email,
      personalId: _profilePreferences.personalId,
      sessionId: _profilePreferences.sessionId,
      profilePhoto: profilePhotoUrl ?? _profilePreferences.profilePhotoUrl,
    );

    return;
  }
}
