import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:koreaislam/data/datasource/preference/preferences_extensions.dart';
import 'package:koreaislam/domain/models/prayer/prayer_name.dart';
import 'package:koreaislam/domain/models/prayer_notification/prayer_notification_lead_time.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Snapshot of the prayer-notification settings — which of the five
/// obligatory prayers fire a reminder and how far in advance. Treated as
/// an immutable value class so the [PrayerNotificationPreferences]
/// notifier can publish atomic updates.
class PrayerNotificationSettings {
  final bool fajrEnabled;
  final bool dhuhrEnabled;
  final bool asrEnabled;
  final bool maghribEnabled;
  final bool ishaEnabled;
  final PrayerNotificationLeadTime leadTime;

  const PrayerNotificationSettings({
    this.fajrEnabled = true,
    this.dhuhrEnabled = true,
    this.asrEnabled = true,
    this.maghribEnabled = true,
    this.ishaEnabled = true,
    this.leadTime = PrayerNotificationLeadTime.tenMinutesBefore,
  });

  bool isEnabled(PrayerName prayer) {
    switch (prayer) {
      case PrayerName.fajr:
        return fajrEnabled;
      case PrayerName.dhuhr:
        return dhuhrEnabled;
      case PrayerName.asr:
        return asrEnabled;
      case PrayerName.maghrib:
        return maghribEnabled;
      case PrayerName.isha:
        return ishaEnabled;
      case PrayerName.sunrise:
        // Sunrise isn't an obligatory prayer; we never schedule it.
        return false;
    }
  }

  PrayerNotificationSettings copyWith({
    bool? fajrEnabled,
    bool? dhuhrEnabled,
    bool? asrEnabled,
    bool? maghribEnabled,
    bool? ishaEnabled,
    PrayerNotificationLeadTime? leadTime,
  }) {
    return PrayerNotificationSettings(
      fajrEnabled: fajrEnabled ?? this.fajrEnabled,
      dhuhrEnabled: dhuhrEnabled ?? this.dhuhrEnabled,
      asrEnabled: asrEnabled ?? this.asrEnabled,
      maghribEnabled: maghribEnabled ?? this.maghribEnabled,
      ishaEnabled: ishaEnabled ?? this.ishaEnabled,
      leadTime: leadTime ?? this.leadTime,
    );
  }

  PrayerNotificationSettings withPrayer(PrayerName prayer, bool enabled) {
    switch (prayer) {
      case PrayerName.fajr:
        return copyWith(fajrEnabled: enabled);
      case PrayerName.dhuhr:
        return copyWith(dhuhrEnabled: enabled);
      case PrayerName.asr:
        return copyWith(asrEnabled: enabled);
      case PrayerName.maghrib:
        return copyWith(maghribEnabled: enabled);
      case PrayerName.isha:
        return copyWith(ishaEnabled: enabled);
      case PrayerName.sunrise:
        return this;
    }
  }
}

/// Persists [PrayerNotificationSettings] across launches. The notifier
/// drives both the settings sheet UI and the [PrayerNotificationScheduler]
/// — any write triggers a reschedule of the local notifications.
class PrayerNotificationPreferences {
  final SharedPreferences _preferences;

  final ValueNotifier<PrayerNotificationSettings> notifier;

  PrayerNotificationPreferences(this._preferences)
      : notifier = ValueNotifier(_readFromPrefs(_preferences));

  static const String _keyFajr = 'prayer_notification_fajr_enabled';
  static const String _keyDhuhr = 'prayer_notification_dhuhr_enabled';
  static const String _keyAsr = 'prayer_notification_asr_enabled';
  static const String _keyMaghrib = 'prayer_notification_maghrib_enabled';
  static const String _keyIsha = 'prayer_notification_isha_enabled';
  static const String _keyLeadTime = 'prayer_notification_lead_time';

  @factoryMethod
  static Future<PrayerNotificationPreferences> create() async {
    final prefs = await SharedPreferences.getInstance();
    return PrayerNotificationPreferences(prefs);
  }

  PrayerNotificationSettings get settings => notifier.value;

  Future<void> setSettings(PrayerNotificationSettings settings) async {
    await _preferences.setOrRemove(_keyFajr, settings.fajrEnabled);
    await _preferences.setOrRemove(_keyDhuhr, settings.dhuhrEnabled);
    await _preferences.setOrRemove(_keyAsr, settings.asrEnabled);
    await _preferences.setOrRemove(_keyMaghrib, settings.maghribEnabled);
    await _preferences.setOrRemove(_keyIsha, settings.ishaEnabled);
    await _preferences.setOrRemove(_keyLeadTime, settings.leadTime.name);
    notifier.value = settings;
  }

  Future<void> setPrayerEnabled(PrayerName prayer, bool enabled) {
    return setSettings(notifier.value.withPrayer(prayer, enabled));
  }

  Future<void> setLeadTime(PrayerNotificationLeadTime leadTime) {
    return setSettings(notifier.value.copyWith(leadTime: leadTime));
  }

  Future<void> clear() async {
    await _preferences.remove(_keyFajr);
    await _preferences.remove(_keyDhuhr);
    await _preferences.remove(_keyAsr);
    await _preferences.remove(_keyMaghrib);
    await _preferences.remove(_keyIsha);
    await _preferences.remove(_keyLeadTime);
    notifier.value = const PrayerNotificationSettings();
  }

  static PrayerNotificationSettings _readFromPrefs(SharedPreferences prefs) {
    return PrayerNotificationSettings(
      fajrEnabled: prefs.getBool(_keyFajr) ?? true,
      dhuhrEnabled: prefs.getBool(_keyDhuhr) ?? true,
      asrEnabled: prefs.getBool(_keyAsr) ?? true,
      maghribEnabled: prefs.getBool(_keyMaghrib) ?? true,
      ishaEnabled: prefs.getBool(_keyIsha) ?? true,
      leadTime: PrayerNotificationLeadTime.valueOrDefault(
        prefs.getString(_keyLeadTime),
      ),
    );
  }
}
