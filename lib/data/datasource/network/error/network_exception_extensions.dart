import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:koreaislam/core/log/logger/app_log.dart';
import 'package:koreaislam/data/datasource/network/error/network_exception.dart';

extension NetworkExceptionCrashlytics on NetworkException {
  Future<void> _setFromHeader(String key, String headerKey) async {
    final value = headers?[headerKey];
    if (value != null) {
      await FirebaseCrashlytics.instance.setCustomKey(key, value.toString());
    }
  }

  Future<void> recordThisErrorToCrashlytics(StackTrace _) async {
    final crashlytics = FirebaseCrashlytics.instance;

    await crashlytics.setCustomKey('exception_type', exceptionName);
    await crashlytics.setCustomKey('timestamp', timestamp.toIso8601String());

    if (endpoint != null) {
      await crashlytics.setCustomKey('endpoint', endpoint!);
    }
    if (statusCode != null) {
      await crashlytics.setCustomKey('status_code', statusCode!);
    }

    if (headers != null) {
      await _setFromHeader('app_version', 'App-Version-Name');
      await _setFromHeader('build_number', 'App-Version-Code');
      await _setFromHeader('device_id', 'Device-Permanent-Id');
      await _setFromHeader('device_name', 'Device-Name');
      await _setFromHeader('mobile_os', 'Mobile-OS');
    }

    for (final entry in extras.entries) {
      await crashlytics.setCustomKey(entry.key, entry.value.toString());
    }

    AppLog.e('Recording to Crashlytics: $this');

    final syntheticStackTrace = StackTrace.fromString(
      '#0      $exceptionName.thrown (package:koreaislam/data/datasource/network/error/${exceptionName.toLowerCase()}.dart:1:1)',
    );

    await crashlytics.recordError(
      this,
      syntheticStackTrace,
      reason: exceptionName,
      fatal: false,
    );
  }
}