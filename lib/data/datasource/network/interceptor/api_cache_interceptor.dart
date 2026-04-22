import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

class ApiCacheInterceptor extends Interceptor {
  final CacheOptions cacheOptions;
  late final DioCacheInterceptor _dioCacheInterceptor;

  ApiCacheInterceptor(this.cacheOptions);

  void init() {
    _dioCacheInterceptor = DioCacheInterceptor(options: cacheOptions);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _dioCacheInterceptor.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _dioCacheInterceptor.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _dioCacheInterceptor.onError(err, handler);
  }
}