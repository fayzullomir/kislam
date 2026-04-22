import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:store_checker/store_checker.dart';
import 'package:koreaislam/core/extensions/string_extensions.dart';
import 'package:koreaislam/core/log/logger/app_log.dart';
import 'package:koreaislam/data/datasource/device/device_info.dart';
import 'package:koreaislam/domain/models/language/language.dart';
import 'package:koreaislam/firebase_options.dart';
import 'package:koreaislam/presentation/application/di/get_it_injection.dart';

import 'presentation/application/application.dart';

/// Background message handler - must be top-level function
/// This handles notifications when app is completely terminated
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Initialize Firebase for background handler
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  AppLog.d('🔔 Background message received: ${message.messageId}');
  AppLog.d('📦 Data: ${message.data}');

  if (message.notification != null) {
    AppLog.d('📬 Title: ${message.notification!.title}');
    AppLog.d('📝 Body: ${message.notification!.body}');
  }

  // Note: System notification is automatically shown by FCM
  // No need to manually show notification here
}

Future<void> main() async {
  runZonedGuarded<Future<void>>(() async {

    // Ensure Flutter is initialized
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize logging
    AppLog.init();

    // Initialize Firebase
    await initializeFirebase();

    // Initialize Firebase Messaging
    await initializeFirebaseMessaging();

    // Initialize dependency injection
    await initializeGetIt();

    // Initialize localization
    await EasyLocalization.ensureInitialized();

    // Get device and app info
    await _getDeviceAndAppInfo();

    // Run the app
    runApp(
      EasyLocalization(
        supportedLocales: Language.values.map((e) => e.locale).toList(),
        path: 'assets/localization',
        fallbackLocale: Language.defaultLanguage.locale,
        child: Application(),
      ),
    );
  }, (error, s) {
    AppLog.e("❌ Application launch error", error: error, stackTrace: s);
    FirebaseCrashlytics.instance.recordError(error, s);
  });
}

/// Initialize Firebase services
Future<void> initializeFirebase() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Enable Crashlytics
    FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

    // Initialize Remote Config
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: const Duration(minutes: 30),
    ));
    await remoteConfig.fetchAndActivate();

    AppLog.i('✅ Firebase initialized successfully');
  } catch (e, s) {
    AppLog.e('❌ Firebase initialization error', error: e, stackTrace: s);
    try {
      FirebaseCrashlytics.instance.recordError(e, s);
    } catch (_) {}
  }
}

/// Initialize Firebase Cloud Messaging
/// Sets up background handler and basic permissions
Future<void> initializeFirebaseMessaging() async {
  try {
    // Set background message handler
    // This must be set before any other FCM operations
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // // Request notification permission (primarily for iOS)
    // await FirebaseMessaging.instance.requestPermission(
    //   alert: true,
    //   announcement: false,
    //   badge: true,
    //   carPlay: false,
    //   criticalAlert: false,
    //   provisional: false,
    //   sound: true,
    // );

    // Configure foreground notification presentation
    // This ensures notifications are shown even when app is in foreground
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Get and log FCM token
    final token = await FirebaseMessaging.instance.getToken();
    AppLog.i('✅ FCM Token: $token');

    AppLog.i('✅ Firebase Messaging initialized successfully');
  } catch (e, s) {
    AppLog.e('❌ Firebase Messaging initialization error', error: e, stackTrace: s);
    try {
      FirebaseCrashlytics.instance.recordError(e, s);
    } catch (_) {}
  }
}

/// Get device and app information
Future<void> _getDeviceAndAppInfo() async {
  try {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    String mobileOS = "Unknown";
    String appSource = "Unknown";
    String deviceName = "Unknown";
    String deviceModel = "Unknown";

    // Determine app installation source
    try {
      Source installationSource = await StoreChecker.getSource;
      appSource = _getSourceName(installationSource);
    } catch (e) {
      Logger().w('⚠️ Could not determine app source: $e');
      appSource = "Unknown";
    }

    // Get platform-specific device info
    if (Platform.isAndroid) {
      AndroidDeviceInfo info = await deviceInfo.androidInfo;
      deviceName = "${info.manufacturer} ${info.model}".capitalizedFirst;
      deviceModel = info.model.capitalizedFirst;
      mobileOS = "Android ${info.version.release}";
    } else if (Platform.isIOS) {
      IosDeviceInfo info = await deviceInfo.iosInfo;
      deviceName = info.name.capitalizedFirst;
      deviceModel = info.utsname.machine.capitalizedFirst;
      mobileOS = "iOS ${info.systemVersion}";
    }

    // Get app version info
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    DeviceInfo.deviceName = deviceName;
    DeviceInfo.deviceModel = deviceModel;
    DeviceInfo.appVersionName = packageInfo.version;
    DeviceInfo.appVersionCode = packageInfo.buildNumber;
    DeviceInfo.appSource = appSource;
    DeviceInfo.mobileOs = mobileOS;

    AppLog.i('✅ Device info collected');
    AppLog.d('📱 Device: $deviceName');
    AppLog.d('📱 OS: $mobileOS');
    AppLog.d('📦 App Version: ${packageInfo.version} (${packageInfo.buildNumber})');
    AppLog.d('🏪 Source: $appSource');
  } catch (e, s) {
    AppLog.e('❌ Error getting device info', error: e, stackTrace: s);
  }
}

/// Get friendly name for installation source
String _getSourceName(Source source) {
  switch (source) {
    case Source.IS_INSTALLED_FROM_PLAY_STORE:
      return "PlayMarket";
    case Source.IS_INSTALLED_FROM_PLAY_PACKAGE_INSTALLER:
      return "PlayPackageInstaller";
    case Source.IS_INSTALLED_FROM_RU_STORE:
      return "RuStore";
    case Source.IS_INSTALLED_FROM_LOCAL_SOURCE:
      return "LocalSource";
    case Source.IS_INSTALLED_FROM_AMAZON_APP_STORE:
      return "AmazonAppStore";
    case Source.IS_INSTALLED_FROM_HUAWEI_APP_GALLERY:
      return "AppGallery";
    case Source.IS_INSTALLED_FROM_SAMSUNG_GALAXY_STORE:
      return "GalaxyStore";
    case Source.IS_INSTALLED_FROM_SAMSUNG_SMART_SWITCH_MOBILE:
      return "SamsungSmartSwitch";
    case Source.IS_INSTALLED_FROM_OPPO_APP_MARKET:
      return "OppoAppMarket";
    case Source.IS_INSTALLED_FROM_XIAOMI_GET_APPS:
      return "XiaomiGetApps";
    case Source.IS_INSTALLED_FROM_VIVO_APP_STORE:
      return "VivoAppStore";
    case Source.IS_INSTALLED_FROM_OTHER_SOURCE:
      return "OtherSource";
    case Source.IS_INSTALLED_FROM_APP_STORE:
      return "AppStore";
    case Source.IS_INSTALLED_FROM_TEST_FLIGHT:
      return "TestFlight";
    case Source.UNKNOWN:
      return "Unknown";
  }
}