import 'package:dio/dio.dart';
import 'package:koreaislam/data/datasource/preference/app_config_preferences.dart';

class LanguageInterceptor extends QueuedInterceptor {
  LanguageInterceptor(this._appConfigPreferences);

  final AppConfigPreferences _appConfigPreferences;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final headers = {
      'Accept-Language': _appConfigPreferences.language.apiCode,
    };
    options.headers.addAll(headers);
    handler.next(options);
  }
}
