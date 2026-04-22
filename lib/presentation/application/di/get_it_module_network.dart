// core/di/get_it_module_network.dart
import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:koreaislam/data/datasource/network/constants/constants.dart';
import 'package:koreaislam/data/datasource/network/interceptor/api_cache_interceptor.dart';
import 'package:koreaislam/data/datasource/network/interceptor/basic_token_interceptor.dart';
import 'package:koreaislam/data/datasource/network/interceptor/bearer_token_interceptor.dart';
import 'package:koreaislam/data/datasource/network/interceptor/cached_bearer_token_interceptor.dart';
import 'package:koreaislam/data/datasource/network/interceptor/common_interceptor.dart';
import 'package:koreaislam/data/datasource/network/interceptor/error_interceptor.dart';
import 'package:koreaislam/data/datasource/network/interceptor/language_interceptor.dart';
import 'package:koreaislam/data/datasource/network/interceptor/refresh_token_interceptor.dart';
import 'package:koreaislam/data/datasource/network/interceptor/user_role_path_interceptor.dart';
import 'package:koreaislam/data/datasource/network/services/article_service.dart';
import 'package:koreaislam/data/datasource/network/services/notification_service.dart';
import 'package:koreaislam/data/datasource/network/services/file_upload_service.dart';
import 'package:koreaislam/data/datasource/network/services/region_service.dart';
import 'package:koreaislam/data/datasource/network/services/session_service.dart';
import 'package:koreaislam/data/datasource/network/services/sign_in_service.dart';
import 'package:koreaislam/data/datasource/network/services/sign_up_service.dart';
import 'package:koreaislam/data/datasource/network/services/profile_service.dart';

const String bearerAuth = "dio_with_bearer_authorization";
const String basicAuth = "dio_with_basic_authorization";
const String cachedAuth = "dio_with_cached_authorization";
//
const String refreshToken = "dio_refresh_token";
//
const String withoutAuth = "dio_without_authorization";

extension GetItModuleNetwork on GetIt {
  Future<void> networkModule() async {
    ///
    /// Cache Store & Options
    ///
    final cacheDir = await getTemporaryDirectory();
    final cacheStore = HiveCacheStore(cacheDir.path);

    registerLazySingleton<CacheStore>(() => cacheStore);

    registerLazySingleton<CacheOptions>(
      () => CacheOptions(
        store: cacheStore,
        policy: CachePolicy.forceCache,
        hitCacheOnErrorExcept: [401, 403, 422],
        maxStale: const Duration(hours: 1),
        // Default
        priority: CachePriority.normal,
        cipher: null,
        keyBuilder: CacheOptions.defaultCacheKeyBuilder,
        allowPostMethod: false,
      ),
    );

    ///
    /// Base interceptors
    ///

    registerLazySingleton(() => BasicTokenInterceptor());
    registerLazySingleton(() => BearerTokenInterceptor(get()));
    registerLazySingleton(() => CachedBearerTokenInterceptor());
    registerLazySingleton(() => CommonInterceptor(get()));
    if (kDebugMode) registerLazySingleton(() => ChuckerDioInterceptor());
    registerLazySingleton(() => LanguageInterceptor(get()));
    registerLazySingleton(() => ErrorInterceptor());
    registerLazySingleton(() => UserRolePathInterceptor(get()));

    // Cache interceptor
    registerLazySingleton(() {
      final cacheInterceptor = ApiCacheInterceptor(get<CacheOptions>());
      cacheInterceptor.init();
      return cacheInterceptor;
    });

    registerLazySingleton(
      () => InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
          options.headers.addAll(<String, String>{});
          handler.next(options);
        },
      ),
    );

    registerLazySingleton(
      () => PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: true,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    );

    BearerTokenInterceptor bearerTokenInterceptor = get();
    BasicTokenInterceptor basicTokenInterceptor = get();
    CachedBearerTokenInterceptor cachedBearerTokenInterceptor = get();
    CommonInterceptor commonInterceptor = get();
    ChuckerDioInterceptor? chuckerDioInterceptor = kDebugMode ? get() : null;
    LanguageInterceptor languageInterceptor = get();
    ErrorInterceptor errorInterceptor = get();
    InterceptorsWrapper headerInterceptor = get();
    PrettyDioLogger loggerInterceptor = get();
    UserRolePathInterceptor userRolePathInterceptor = get();
    ApiCacheInterceptor apiCacheInterceptor = get();

    ///
    /// Refresh token interceptor
    ///

    registerSingleton<Dio>(
      provideDio(
        interceptors: [
          userRolePathInterceptor,
          commonInterceptor,
          languageInterceptor,
          loggerInterceptor,
          if (kDebugMode) chuckerDioInterceptor!,
          errorInterceptor,
          headerInterceptor,
        ],
      ),
      instanceName: refreshToken,
    );

    registerLazySingleton(() => RefreshTokenInterceptor(
          get(),
          get(instanceName: refreshToken),
          get(),
          get(),
        ));

    RefreshTokenInterceptor refreshTokenInterceptor = get();

    ///
    /// Public dio and services
    ///

    registerSingleton<Dio>(
      provideDio(
        interceptors: [
          userRolePathInterceptor,
          // apiCacheInterceptor, // Cache for public endpoints
          commonInterceptor,
          languageInterceptor,
          loggerInterceptor,
          if (kDebugMode) chuckerDioInterceptor!,
          errorInterceptor,
          headerInterceptor,
        ],
      ),
      instanceName: withoutAuth,
    );

    registerLazySingleton(() => SignInService(get(instanceName: withoutAuth)));
    registerLazySingleton(() => SignUpService(get(instanceName: withoutAuth)));

    ///
    /// Providing fixed dio and services
    ///

    registerSingleton<Dio>(
      provideDio(
        interceptors: [
          userRolePathInterceptor,
          cachedBearerTokenInterceptor,
          commonInterceptor,
          languageInterceptor,
          loggerInterceptor,
          if (kDebugMode) chuckerDioInterceptor!,
          errorInterceptor,
          headerInterceptor,
        ],
      ),
      instanceName: cachedAuth,
    );

    registerLazySingleton(() => NotificationService(
          bearerDio: get(instanceName: bearerAuth),
          cachedDio: get(instanceName: cachedAuth),
        ));

    registerLazySingleton(() => SessionService(
          bearerDio: get(instanceName: bearerAuth),
          cachedDio: get(instanceName: cachedAuth),
        ));

    ///
    /// Providing dio and services WITH BASIC authentication
    ///

    registerSingleton<Dio>(
      provideDio(
        interceptors: [
          userRolePathInterceptor,
          basicTokenInterceptor,
          // apiCacheInterceptor, // Cache for basic auth endpoints
          commonInterceptor,
          languageInterceptor,
          loggerInterceptor,
          if (kDebugMode) chuckerDioInterceptor!,
          errorInterceptor,
          headerInterceptor,
        ],
      ),
      instanceName: basicAuth,
    );

    registerLazySingleton(() => RegionService(get(instanceName: basicAuth)));

    ///
    /// Providing private dio and services
    ///

    registerSingleton<Dio>(
      provideDio(
        interceptors: [
          userRolePathInterceptor,
          bearerTokenInterceptor,
          refreshTokenInterceptor,
          // apiCacheInterceptor, // Cache for authenticated endpoints
          commonInterceptor,
          languageInterceptor,
          loggerInterceptor,
          if (kDebugMode) chuckerDioInterceptor!,
          errorInterceptor,
          headerInterceptor,
        ],
      ),
      instanceName: bearerAuth,
    );

    registerLazySingleton(() => ArticleService(
          bearerAuth: get(instanceName: bearerAuth),
          withoutAuth: get(instanceName: withoutAuth),
        ));
    registerLazySingleton(() => FileUploadService(get(
          instanceName: bearerAuth,
        )));
    registerLazySingleton(() => ProfileService(get(instanceName: bearerAuth)));

    await allReady();
  }
}

Dio provideDio({List<Interceptor> interceptors = const []}) {
  final Dio dio = Dio();

  final timeout = Duration(seconds: 120);
  final options = BaseOptions(
    baseUrl: Constants.baseUrl,
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  dio.options = options
    ..connectTimeout = timeout
    ..receiveTimeout = timeout
    ..sendTimeout = timeout;

  dio.interceptors.addAll(interceptors);

  return dio;
}
