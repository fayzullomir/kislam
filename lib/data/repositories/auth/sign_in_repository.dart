import 'dart:async';

import 'package:koreaislam/core/log/logger/app_log.dart';
import 'package:koreaislam/data/datasource/network/dto/auth/check/auth_check_response.dart';
import 'package:koreaislam/data/datasource/network/dto/auth/sign_in/sign_in_response.dart';
import 'package:koreaislam/data/datasource/network/services/sign_in_service.dart';
import 'package:koreaislam/data/datasource/preference/auth_preferences.dart';
import 'package:koreaislam/data/datasource/preference/profile_preferences.dart';
import 'package:koreaislam/domain/channels/login_event_channel.dart';
import 'package:koreaislam/domain/models/login/login_event.dart';
import 'package:koreaislam/domain/models/user/user_role.dart';

class SignInRepository {
  final AuthPreferences _authPreferences;
  final LoginEventChannel _loginEventChannel;
  final ProfilePreferences _profilePreferences;
  final SignInService _signInService;

  SignInRepository(
    this._authPreferences,
    this._loginEventChannel,
    this._signInService,
    this._profilePreferences,
  );

  Future<AuthCheckResponse> checkUserName(String username) async {
    var response = await _signInService.check(username: username);
    AppLog.e("checkUserName response = $response");
    var authCheckResponse = AuthCheckResponse.fromJson(response.data);
    return authCheckResponse;
  }

  Future<void> signIn(String phoneNumber, String password) async {
    AppLog.d("AuthRepository => login $phoneNumber $password");
    final response = await _signInService.signIn(
      username: phoneNumber,
      password: password,
    );

    final signInResponse = SignInResponse.fromJson(response.data);

    await _authPreferences.setAccessToken(signInResponse.accessToken);
    await _authPreferences.setRefreshToken(signInResponse.refreshToken);
    await _authPreferences.setIsAuthorized(true);

    AppLog.e("signIn userType = ${signInResponse.userType}");

    await _profilePreferences.setUserProfile(
      id: signInResponse.userId,
      firstName: "",
      lastName: "",
      phoneNumber: phoneNumber,
      userRole: UserRole.valueOrDefault(signInResponse.userType),
      email: "",
      personalId: "",
      sessionId: "",
      profilePhoto: "",
    );

    _loginEventChannel.add(LoginEvent.onSignInWithAccount);

    return;
  }
}
