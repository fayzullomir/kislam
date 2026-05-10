import 'package:get_it/get_it.dart';
import 'package:koreaislam/data/datasource/preference/app_config_preferences.dart';
import 'package:koreaislam/data/datasource/preference/auth_preferences.dart';
import 'package:koreaislam/data/datasource/preference/calculation_method_preferences.dart';
import 'package:koreaislam/data/datasource/preference/device_preference.dart';
import 'package:koreaislam/data/datasource/preference/fcm_token_preferences.dart';
import 'package:koreaislam/data/datasource/preference/location_preferences.dart';
import 'package:koreaislam/data/datasource/preference/madhab_preferences.dart';
import 'package:koreaislam/data/datasource/preference/prayer_notification_preferences.dart';
import 'package:koreaislam/data/datasource/preference/quran_translation_preferences.dart';
import 'package:koreaislam/data/datasource/preference/theme_mode_preferences.dart';
import 'package:koreaislam/data/datasource/preference/profile_preferences.dart';

extension GetItModulePreference on GetIt {
  Future<void> preferencesModule() async {
    registerSingletonAsync(() async => await AppConfigPreferences.create());
    registerSingletonAsync(() async => await AuthPreferences.create());
    registerSingletonAsync(() async => await DevicePreferences.create());
    registerSingletonAsync(() async => await FcmTokenPreferences.create());
    registerSingletonAsync(() async => await ThemeModePreferences.create());
    registerSingletonAsync(() async => await LocationPreferences.create());
    registerSingletonAsync(() async => await MadhabPreferences.create());
    registerSingletonAsync(() async => await CalculationMethodPreferences.create());
    registerSingletonAsync(() async => await PrayerNotificationPreferences.create());
    registerSingletonAsync(() async => await QuranTranslationPreferences.create());
    registerSingletonAsync(() async => await ProfilePreferences.create());
    await allReady();
  }
}
