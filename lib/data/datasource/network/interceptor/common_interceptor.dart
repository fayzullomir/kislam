import 'package:dio/dio.dart';
import 'package:koreaislam/data/datasource/device/device_info.dart';
import 'package:koreaislam/data/datasource/preference/device_preference.dart';

class CommonInterceptor extends QueuedInterceptor {
  final DevicePreferences _devicePreferences;

  CommonInterceptor(this._devicePreferences);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final headers = <String, String>{};

    headers['App-Version-Name'] = DeviceInfo.appVersionName;
    headers['App-Version-Code'] = DeviceInfo.appVersionCode;

    headers['Device-Permanent-Id'] = _devicePreferences.devicePermanentId;
    headers['Device-Id'] = _devicePreferences.deviceSessionId;
    headers['Device-Name'] = DeviceInfo.deviceName;
    headers['Device-Model'] = DeviceInfo.deviceModel;

    headers['Mobile-OS'] = DeviceInfo.mobileOs;

    headers['App-Source'] = DeviceInfo.appSource;

    options.headers.addAll(headers);
    handler.next(options);
  }
}
