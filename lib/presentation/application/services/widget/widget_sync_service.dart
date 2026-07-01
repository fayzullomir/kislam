import 'dart:convert';
import 'dart:io';

import 'package:home_widget/home_widget.dart';
import 'package:koreaislam/core/gen/localization/strings.dart';
import 'package:koreaislam/core/log/logger/app_log.dart';
import 'package:koreaislam/data/datasource/preference/app_config_preferences.dart';
import 'package:koreaislam/data/datasource/preference/calculation_method_preferences.dart';
import 'package:koreaislam/data/datasource/preference/location_preferences.dart';
import 'package:koreaislam/data/datasource/preference/madhab_preferences.dart';
import 'package:koreaislam/data/repositories/prayer_times/prayer_times_repository.dart';
import 'package:koreaislam/domain/models/location/user_location.dart';
import 'package:koreaislam/presentation/application/services/widget/prayer_widget_payload.dart';

/// Pushes prayer-time data to the native home-screen widgets (Android
/// AppWidget + iOS WidgetKit) via the `home_widget` bridge. Computes two
/// days of times and pre-localized labels so the native renderers never
/// recompute and the widget stays correct across the day boundary even
/// when the app isn't opened.
///
/// Re-pushes whenever the location / madhab / calculation method changes
/// (the same signals that drive the notification scheduler) and whenever
/// the host calls [refresh] (app launch / resume).
class WidgetSyncService {
  final PrayerTimesRepository _prayerTimesRepository;
  final LocationPreferences _locationPreferences;
  final MadhabPreferences _madhabPreferences;
  final CalculationMethodPreferences _calculationMethodPreferences;
  final AppConfigPreferences _appConfigPreferences;

  WidgetSyncService(
    this._prayerTimesRepository,
    this._locationPreferences,
    this._madhabPreferences,
    this._calculationMethodPreferences,
    this._appConfigPreferences,
  );

  static const String _appGroupId = 'group.org.koreaislam.mobile';
  static const String _androidWidgetName = 'PrayerWidgetProvider';
  static const String _iosWidgetName = 'PrayerWidget';
  static const String _payloadKey = 'prayer_widget_payload';

  bool _initialized = false;

  bool get _isSupported => Platform.isAndroid || Platform.isIOS;

  /// Wire up listeners and push the first payload. Safe to call multiple
  /// times — only the first call registers listeners.
  Future<void> init() async {
    if (!_isSupported || _initialized) return;
    _initialized = true;

    try {
      await HomeWidget.setAppGroupId(_appGroupId);
    } catch (e, s) {
      AppLog.e('❌ Widget app group setup failed', error: e, stackTrace: s);
    }

    _locationPreferences.notifier.addListener(_onPreferenceChanged);
    _madhabPreferences.notifier.addListener(_onPreferenceChanged);
    _calculationMethodPreferences.notifier.addListener(_onPreferenceChanged);

    await refresh();
  }

  void _onPreferenceChanged() => refresh();

  /// Rebuild the payload and tell the OS to redraw the widgets.
  Future<void> refresh() async {
    if (!_isSupported) return;

    try {
      final payload = _buildPayload();
      await HomeWidget.saveWidgetData<String>(
        _payloadKey,
        jsonEncode(payload.toJson()),
      );
      await HomeWidget.updateWidget(
        androidName: _androidWidgetName,
        iOSName: _iosWidgetName,
      );
      AppLog.d('✅ Prayer widget refreshed (${payload.days.length} day(s))');
    } catch (e, s) {
      AppLog.e('❌ Prayer widget refresh failed', error: e, stackTrace: s);
    }
  }

  PrayerWidgetPayload _buildPayload() {
    final now = DateTime.now();
    final today = _prayerTimesRepository.computeForDate(now);
    final tomorrow = _prayerTimesRepository.computeForDate(
      now.add(const Duration(days: 1)),
    );

    final days = <PrayerWidgetDay>[
      if (today != null) PrayerWidgetDay.fromTimes(today),
      if (tomorrow != null) PrayerWidgetDay.fromTimes(tomorrow),
    ];

    return PrayerWidgetPayload(
      language: _appConfigPreferences.language.name,
      locationLabel: _resolveLocationLabel(_locationPreferences.location),
      generatedAt: now.millisecondsSinceEpoch,
      labels: {
        'title': Strings.homeQuickLinkMonthlyPrayerTimesSubtitle,
        'fajr': Strings.prayerFajr,
        'sunrise': Strings.prayerSunrise,
        'dhuhr': Strings.prayerDhuhr,
        'asr': Strings.prayerAsr,
        'maghrib': Strings.prayerMaghrib,
        'isha': Strings.prayerIsha,
        'noLocation': Strings.monthlyPrayerTimesNoLocation,
      },
      days: days,
    );
  }

  String? _resolveLocationLabel(UserLocation location) {
    if (location.city?.isNotEmpty == true) return location.city;
    final label = location.displayLabel;
    return label.isNotEmpty ? label : null;
  }
}
