import 'dart:async';

import 'package:dio/dio.dart';
import 'package:koreaislam/domain/models/gender/gender.dart';
import 'package:koreaislam/domain/models/region/country.dart';
import 'package:koreaislam/domain/models/region/district.dart';
import 'package:koreaislam/domain/models/region/region.dart';

class SignUpService {
  final Dio _dio;

  SignUpService(this._dio);

  Future<Response> signUp({
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
  }) {
    final body = {
      "user_type": userType,
      "username": phoneNumber,
      "first_name": firstName,
      "last_name": lastName,
      "gender": gender.apiCode,
      "birth_date": dateOfBirth,
      "profile_photo": profilePhoto,
      "email": email,
      "country_id": country.id,
      "region_id": region.id,
      "district_id": district.id,
      "password": password,
    };
    return _dio.post(
      'mobile/user/sign-up',
      data: body,
    );
  }

  Future<Response> requestOtpCode({
    required String phoneNumber,
    required String otpToken,
    required String otpSignature,
  }) {
    final queryParams = {
      "phone": phoneNumber,
      "token": otpToken,
      "otp_signature": otpSignature,
      "verification_type": "SMS", // fixme use types SMS, Telegram, WhatsApp
    };
    return _dio.get(
      'mobile/auth/verification/request-code',
      queryParameters: queryParams,
    );
  }

  Future<Response> verifyOtpCode({
    required String phoneNumber,
    required String otpCode,
    required String otpToken,
    required String userType,
  }) {
    final bodyData = {
      "phone": phoneNumber,
      "code": otpCode,
      "token": otpToken,
      "user_type": userType,
    };
    return _dio.post(
      'mobile/auth/verification/verify',
      data: bodyData,
    );
  }
}
