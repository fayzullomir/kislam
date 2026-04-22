import 'package:koreaislam/data/datasource/preference/temporarily_data_holder.dart';
import 'package:dio/dio.dart';

class CachedBearerTokenInterceptor extends Interceptor {
  CachedBearerTokenInterceptor();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    var accessToken = TemporarilyDataHolder.accessToken;
    if (accessToken.isNotEmpty) {
      final headers = {"Authorization": "Bearer $accessToken"};
      options.headers.addAll(headers);
    }

    handler.next(options);
  }
}
