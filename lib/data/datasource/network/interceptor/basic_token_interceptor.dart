import 'package:dio/dio.dart';

class BasicTokenInterceptor extends Interceptor {
  BasicTokenInterceptor();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final headers = {"Authorization": "Basic dW1ybG5rOlVybWFja2wxMDAxIQ=="};
    options.headers.addAll(headers);

    handler.next(options);
  }
}
