import 'dart:async';

import 'package:smart_auth/smart_auth.dart';
import 'package:koreaislam/core/log/logger/app_log.dart';
import 'package:koreaislam/data/datasource/network/dto/auth/sign_up/sign_up_response.dart';
import 'package:koreaislam/data/datasource/network/dto/auth/verification/send_otp_response.dart';
import 'package:koreaislam/data/datasource/network/dto/auth/verification/verify_otp_response.dart';
import 'package:koreaislam/data/datasource/network/services/sign_up_service.dart';
import 'package:koreaislam/data/datasource/preference/auth_preferences.dart';
import 'package:koreaislam/data/datasource/preference/profile_preferences.dart';
import 'package:koreaislam/domain/channels/login_event_channel.dart';
import 'package:koreaislam/domain/models/gender/gender.dart';
import 'package:koreaislam/domain/models/login/login_event.dart';
import 'package:koreaislam/domain/models/region/country.dart';
import 'package:koreaislam/domain/models/region/district.dart';
import 'package:koreaislam/domain/models/region/region.dart';
import 'package:koreaislam/domain/models/user/user_role.dart';

class SignUpRepository {
  final AuthPreferences _authPreferences;
  final LoginEventChannel _loginEventChannel;
  final ProfilePreferences _profilePreferences;
  final SignUpService _signUpService;

  SignUpRepository(
    this._authPreferences,
    this._loginEventChannel,
    this._signUpService,
    this._profilePreferences,
  );

  Future<SignUpResponse> signUp({
    required String userType,
    required String phoneNumber,
    required String firstName,
    required String lastName,
    required Gender gender,
    required String dateOfBirth,
    required String? email,
    required String? profilePhoto,
    required Country country,
    required Region region,
    required District district,
    required String password,
  }) async {
    var response = await _signUpService.signUp(
      userType: userType,
      phoneNumber: phoneNumber,
      firstName: firstName,
      lastName: lastName,
      gender: gender,
      dateOfBirth: dateOfBirth,
      email: email,
      profilePhoto: profilePhoto,
      country: country,
      region: region,
      district: district,
      password: password,
    );
    var signUpResponse = SignUpResponse.fromJson(response.data);

    _authPreferences.setAccessToken(signUpResponse.accessToken);
    _authPreferences.setRefreshToken(signUpResponse.refreshToken);
    _authPreferences.setIsAuthorized(true);

    _profilePreferences.setUserProfile(
      id: signUpResponse.userId,
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phoneNumber,
      email: email,
      userRole: UserRole.valueOrDefault(signUpResponse.userType),
      personalId: "",
      sessionId: "",
      profilePhoto: "",
    );

    _loginEventChannel.add(LoginEvent.onSignUpWithAccount);

    return signUpResponse;
  }

  Future<SendOtpResponse> requestOtpCode({
    required String phoneNumber,
    required String otpToken,
    required String userType,
  }) async {

    final signature = await SmartAuth().getAppSignature() ?? "SYz1nLRATrU";
    AppLog.e("requestOtpCode OTP Signature: $signature");

    var response = await _signUpService.requestOtpCode(
      phoneNumber: phoneNumber,
      otpToken: otpToken,
      otpSignature: signature,
    );
    var sendOtpResponse = SendOtpResponse.fromJson(response.data);
    return sendOtpResponse;
  }

  Future<VerifyOtpResponse> verifyOtpCode({
    required String phoneNumber,
    required String otpCode,
    required String otpToken,
    required String userType,
  }) async {
    var response = await _signUpService.verifyOtpCode(
      phoneNumber: phoneNumber,
      otpCode: otpCode,
      otpToken: otpToken,
      userType: userType,
    );
    var verifyOtpResponse = VerifyOtpResponse.fromJson(response.data);
    return verifyOtpResponse;
  }
}
