import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

/// Week cache (7 days) - for currencies, countries
Options weekCacheOptions({bool forceRefresh = false}) =>
    _cache(days: 7, hours: 0, forceRefresh: forceRefresh);

/// Day cache (24 hours) - for hotels, services
Options dayCacheOptions({bool forceRefresh = false}) =>
    _cache(days: 0, hours: 24, forceRefresh: forceRefresh);

/// Hour cache (1 hour) - for dynamic data
Options hourCacheOptions({bool forceRefresh = false}) =>
    _cache(days: 0, hours: 1, forceRefresh: forceRefresh);

/// No cache
Options noCacheOptions() => Options(
  extra: {
    'dio_cache_policy': CachePolicy.noCache,
  },
);

Options _cache({
  required int days,
  required int hours,
  required bool forceRefresh,
}) {
  return Options(
    extra: {
      'dio_cache_policy': forceRefresh
          ? CachePolicy.refresh
          : CachePolicy.forceCache,
      'dio_cache_max_stale': Duration(days: days, hours: hours),
    },
  );
}