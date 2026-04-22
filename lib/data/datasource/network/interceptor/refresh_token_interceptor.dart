import 'package:dio/dio.dart';
import 'package:koreaislam/core/log/logger/app_log.dart';
import 'package:koreaislam/data/datasource/network/dto/auth/refresh_token/refresh_token_request.dart';
import 'package:koreaislam/data/datasource/network/error/refresh_token_failed_exception.dart';
import 'package:koreaislam/data/datasource/network/error/token_expired_exception.dart';
import 'package:koreaislam/data/datasource/preference/auth_preferences.dart';
import 'package:koreaislam/data/datasource/preference/profile_preferences.dart';
import 'package:koreaislam/domain/channels/logout_event_channel.dart';
import 'package:koreaislam/domain/models/logout_event/logout_event_type.dart';

class RefreshTokenInterceptor extends Interceptor {
  final AuthPreferences _authPreferences;
  final Dio _dio;
  final LogoutEventChannel _logoutEventChannel;
  final ProfilePreferences _profilePreferences;

  RefreshTokenInterceptor(
    this._authPreferences,
    this._dio,
    this._logoutEventChannel,
    this._profilePreferences,
  );

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response == null) return handler.next(err);

    final statusCode = err.response?.statusCode;
    if (statusCode != null && statusCode == 401) {
      AppLog.w("RefreshToken onError access token expired");
      await TokenExpiredException(
        message: "",
        endpoint: err.requestOptions.path,
        headers: err.requestOptions.headers,
        statusCode: statusCode,
        extras: {},
      ).recordToCrashlytics();

      try {
        final retryResponse = await _retrySendRequest(
          err.requestOptions,
          err.response,
        );

        if (retryResponse != null && retryResponse.statusCode == 200) {
          return handler.resolve(retryResponse);
        } else {
          return handler.next(err);
        }
      } on DioException catch (e, s) {
        AppLog.e("RefreshToken onError retry error: $e, s: $s");

        await RefreshTokenFailedException(
          message: 'Retry after refresh token failed',
          endpoint: e.requestOptions.path,
          statusCode: e.response?.statusCode,
          headers: e.requestOptions.headers,
          extras: {},
        ).recordToCrashlytics();

        return handler.next(e);
      }
    }

    return handler.next(err);
  }

  Future<bool> _refreshToken() async {
    var refreshToken = _authPreferences.refreshToken;
    if (refreshToken.isEmpty) {
      AppLog.w("RefreshToken refreshing will skipped refreshToken not exist");
      return false;
    }

    try {
      final response = await _dio.post(
        '/mobile/auth/refresh-token',
        data: RefreshTokenRequest(
          refreshToken: _authPreferences.refreshToken,
          userType: _profilePreferences.userRole.apiValue,
        ),
      );
      AppLog.i("RefreshToken refreshing response = $response");
      if (response.statusCode == 200) {
        final accessToken = response.data['access_token'];
        final refreshToken = response.data['refresh_token'];
        AppLog.i("RefreshToken access = $accessToken, refresh = $refreshToken");
        _authPreferences.setAccessToken(accessToken);
        _authPreferences.setRefreshToken(refreshToken);

        return true;
      }
      return false;
    } catch (e) {
      AppLog.e("RefreshToken error", error: e);
      return false;
    }
  }

  Future<Response?> _retrySendRequest(
    RequestOptions requestOptions,
    Response? failedResponse,
  ) async {
    try {
      final isRefreshed = await _refreshToken();
      if (isRefreshed) {
        var accessToken = _authPreferences.accessToken;
        requestOptions.headers["Authorization"] = "Bearer $accessToken";

        final retryResponse = await _dio.request(
          requestOptions.path,
          options: Options(
            method: requestOptions.method,
            headers: requestOptions.headers,
          ),
          data: requestOptions.data,
          queryParameters: requestOptions.queryParameters,
        );

        AppLog.i("RefreshToken retrySendRequest = $retryResponse");

        return retryResponse;
      } else {
        AppLog.w("RefreshToken retrySendRequest failed => data will cleared");
        _logoutEventChannel.add(LogoutEvent.onTokenExpired);

        return failedResponse;
      }
    } catch (e) {
      AppLog.e("RefreshToken retrySendRequest error", error: e);
      return failedResponse;
    }
  }
}
