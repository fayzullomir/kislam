import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:koreaislam/core/extensions/string_extensions.dart';
import 'package:koreaislam/core/log/logger/app_log.dart';
import 'package:url_launcher/url_launcher.dart';

/// Launches phone dialer with given phone number
Future<bool> openPhoneDialer(
  String phoneNumber, {
  Function(Object? error, StackTrace? stackTrace)? errorCallback,
}) async {
  try {
    final normalized = phoneNumber.formatted.withoutWhitespace;
    final uri = Uri.parse('tel:+$normalized');

    AppLog.i("Launching dialer: +$normalized");

    return await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
  } catch (e, s) {
    AppLog.e("Failed to launch dialer", error: e, stackTrace: s);
    FirebaseCrashlytics.instance.recordError(e, s);
    errorCallback?.call(e, s);
    return false;
  }
}

/// Launches url dialer with given phone number
Future<bool> openCustomTab(
  String url, {
  Function(Object? error, StackTrace? stackTrace)? errorCallback,
}) async {
  try {
    var uri = Uri.parse(url);
    return await launchUrl(uri);
  } catch (e, s) {
    AppLog.e("Failed to launch dialer", error: e, stackTrace: s);
    FirebaseCrashlytics.instance.recordError(e, s);

    errorCallback?.call(e, s);
    return false;
  }
}
