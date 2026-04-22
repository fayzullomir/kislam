// error_interceptor.dart

import 'package:koreaislam/core/log/logger/app_log.dart';
import 'package:koreaislam/data/datasource/network/dto/default/default_error_response.dart';
import 'package:koreaislam/data/datasource/network/error/auth_check_failed_exception.dart';
import 'package:koreaislam/data/datasource/network/error/otp_request_failed_exception.dart';
import 'package:koreaislam/data/datasource/network/error/otp_verify_failed_exception.dart';
import 'package:koreaislam/data/datasource/network/error/sign_in_failed_exception.dart';
import 'package:koreaislam/data/datasource/network/error/sign_up_failed_exception.dart';
import 'package:koreaislam/data/mappers/dio_error_mappers.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:koreaislam/presentation/support/extensions/extension_message_exts.dart';

@lazySingleton
class ErrorInterceptor extends InterceptorsWrapper {
  // Auth endpoints
  static final _authCheck = RegExp(r'mobile/auth/check');
  static final _signIn = RegExp(r'mobile/auth/sign-in');
  static final _signUp = RegExp(r'mobile/user/sign-up');
  static final _otpRequest = RegExp(r'mobile/auth/verification/request-code');
  static final _otpVerify = RegExp(r'mobile/auth/verification/verify');

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final statusCode = response.statusCode;
    if (statusCode == null || (statusCode < 200 && statusCode > 299)) {
      DefaultErrorResponse? error;
      try {
        final data = response.data;
        AppLog.d('onResponse error payload type: \\${data.runtimeType}');
        error = DefaultErrorResponse.safeParse(data);
      } catch (e, s) {
        AppLog.e(
          "onResponse Error parsing default error response",
          error: e,
          stackTrace: s,
        );
      }
      final exception = response.dioResponseToAppException(error?.detailMessage);
      AppLog.e("onResponse s = $statusCode, r = $response, e = $exception");

      // Используем handler.reject() вместо throw
      handler.reject(
        DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: exception,
          message: exception.localizedMessage,
        ),
      );
      return;
    }
    super.onResponse(response, handler);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    String? detailMessage;

    if (err.response?.data != null) {
      try {
        final data = err.response!.data;
        AppLog.d('onError error payload type: \\${data.runtimeType}');
        detailMessage = DefaultErrorResponse.safeParse(data)?.detailMessage;
      } catch (e, s) {
        AppLog.e(
          "onError error parsing default error response",
          error: e,
          stackTrace: s,
        );
      }
    }

    await _trackEndpointError(err, detailMessage);

    final exception = err.dioExceptionToAppException(detailMessage);
    AppLog.e("onError => dio e = $err app e = $exception");

    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: exception,
        stackTrace: err.stackTrace,
        message: exception.localizedMessage,
      ),
    );
  }

  Future<void> _trackEndpointError(DioException err, String? message) async {
    final endpoint = err.requestOptions.path;
    final statusCode = err.response?.statusCode;
    final headers = err.requestOptions.headers;

    // Auth check
    if (_authCheck.hasMatch(endpoint)) {
      await AuthCheckFailedException(
        message: message ?? 'Auth check failed',
        endpoint: endpoint,
        statusCode: statusCode,
        headers: headers,
        extras: _extractQueryParams(err.requestOptions, ['username']),
      ).recordToCrashlytics();
      return;
    }

    // Sign in
    if (_signIn.hasMatch(endpoint)) {
      await SignInFailedException(
        message: message ?? 'Sign in failed',
        endpoint: endpoint,
        statusCode: statusCode,
        headers: headers,
        extras: {},
      ).recordToCrashlytics();
      return;
    }

    // Sign up
    if (_signUp.hasMatch(endpoint)) {
      await SignUpFailedException(
        message: message ?? 'Sign up failed',
        endpoint: endpoint,
        statusCode: statusCode,
        headers: headers,
        extras: _extractBodyParams(err.requestOptions, ['user_type', 'country_id', 'region_id']),
      ).recordToCrashlytics();
      return;
    }

    // OTP request
    if (_otpRequest.hasMatch(endpoint)) {
      await OtpRequestFailedException(
        message: message ?? 'OTP request failed',
        endpoint: endpoint,
        statusCode: statusCode,
        headers: headers,
        extras: {'step': 'request_otp'},
      ).recordToCrashlytics();
      return;
    }

    // OTP verify
    if (_otpVerify.hasMatch(endpoint)) {
      await OtpVerifyFailedException(
        message: message ?? 'OTP verify failed',
        endpoint: endpoint,
        statusCode: statusCode,
        headers: headers,
        extras: {'step': 'verify_otp'},
      ).recordToCrashlytics();
      return;
    }
  }

  Map<String, dynamic> _extractQueryParams(RequestOptions options, List<String> keys) {
    final params = <String, dynamic>{};
    for (final key in keys) {
      final value = options.queryParameters[key];
      if (value != null) {
        params[key] = _maskSensitive(key, value.toString());
      }
    }
    return params;
  }

  Map<String, dynamic> _extractBodyParams(RequestOptions options, List<String> keys) {
    final params = <String, dynamic>{};
    final data = options.data;
    if (data is Map<String, dynamic>) {
      for (final key in keys) {
        final value = data[key];
        if (value != null) {
          params[key] = _maskSensitive(key, value.toString());
        }
      }
    }
    return params;
  }

  String _maskSensitive(String key, String value) {
    const sensitiveKeys = ['username', 'phone', 'email', 'password'];
    if (sensitiveKeys.contains(key)) {
      if (value.length <= 4) return '****';
      return '${value.substring(0, 3)}***${value.substring(value.length - 2)}';
    }
    return value;
  }
}