import 'dart:async';

import 'package:dio/dio.dart';

class SignInService {
  final Dio _dio;

  SignInService(this._dio);

  Future<Response> check({
    required String username,
  }) {
    final queryParams = {"username": username};
    return _dio.get(
      'mobile/auth/check',
      queryParameters: queryParams,
    );
  }

  Future<Response> signIn({
    required String username,
    required String password,
  }) {
    final bodyData = FormData.fromMap({
      "username": username,
      "password": password,
    });
    return _dio.post(
      'mobile/auth/sign-in',
      data: bodyData,
    );
  }
}
