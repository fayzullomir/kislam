import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:koreaislam/core/gen/localization/strings.dart';
import 'package:koreaislam/core/log/logger/app_log.dart';
import 'package:koreaislam/data/datasource/preference/calculation_method_preferences.dart';
import 'package:koreaislam/data/datasource/preference/location_preferences.dart';
import 'package:koreaislam/data/datasource/preference/madhab_preferences.dart';
import 'package:koreaislam/data/datasource/preference/prayer_notification_preferences.dart';
import 'package:koreaislam/data/repositories/prayer_times/prayer_times_repository.dart';
import 'package:koreaislam/domain/models/prayer/daily_prayer_times.dart';
import 'package:koreaislam/domain/models/prayer/prayer_name.dart';
import 'package:koreaislam/domain/models/prayer_notification/prayer_notification_lead_time.dart';
import 'package:koreaislam/utils/extensions/resource_extensions.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// Schedules local notifications for the five obligatory prayers using
/// [flutter_local_notifications]'s `zonedSchedule`. The lead-time
/// (instantly / 5 / 10 minutes) and per-prayer toggles come from
/// [PrayerNotificationPreferences].
///
/// The scheduler is idempotent — every reschedule call cancels the
/// previous batch and writes a fresh one for today + tomorrow. We don't
/// rely on a daily-recurring trigger because the prayer DateTime drifts
/// by a few minutes day-over-day; recomputing is cheaper than maintaining
/// a 365-day schedule.
class PrayerNotificationScheduler {
  PrayerNotificationScheduler({
    required FlutterLocalNotificationsPlugin plugin,
    required PrayerTimesRepository prayerTimesRepository,
    required PrayerNotificationPreferences prayerNotificationPreferences,
    required LocationPreferences locationPreferences,
    required MadhabPreferences madhabPreferences,
    required CalculationMethodPreferences calculationMethodPreferences,
  })  : _plugin = plugin,
        _prayerTimesRepository = prayerTimesRepository,
        _prayerNotificationPreferences = prayerNotificationPreferences,
        _locationPreferences = locationPreferences,
        _madhabPreferences = madhabPreferences,
        _calculationMethodPreferences = calculationMethodPreferences;

  static const int _idBase = 7000;
  static const String _channelId = 'prayer_times_channel';
  static const String _channelName = 'Prayer Times';
  static const String _channelDescription =
      'Reminders before each daily prayer';

  final FlutterLocalNotificationsPlugin _plugin;
  final PrayerTimesRepository _prayerTimesRepository;
  final PrayerNotificationPreferences _prayerNotificationPreferences;
  final LocationPreferences _locationPreferences;
  final MadhabPreferences _madhabPreferences;
  final CalculationMethodPreferences _calculationMethodPreferences;

  bool _initialized = false;

  /// One-shot setup: load the timezone database and tell
  /// `tz` which zone the device is in. Must run before any
  /// `zonedSchedule` call.
  Future<void> init() async {
    if (_initialized) return;
    try {
      tz_data.initializeTimeZones();
      final localName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(localName));
      _initialized = true;
      AppLog.i('✅ Prayer scheduler initialized (tz=$localName)');

      _wireListeners();
    } catch (e, s) {
      AppLog.e(
        '❌ Prayer scheduler init failed',
        error: e,
        stackTrace: s,
      );
    }
  }

  /// Listens to every preference that affects the schedule. Any change
  /// triggers a reschedule so the next reminder always reflects the
  /// latest user choice.
  void _wireListeners() {
    _prayerNotificationPreferences.notifier.addListener(rescheduleAll);
    _locationPreferences.notifier.addListener(rescheduleAll);
    _madhabPreferences.notifier.addListener(rescheduleAll);
    _calculationMethodPreferences.notifier.addListener(rescheduleAll);
  }

  /// Cancels every prayer-time notification and re-schedules them for
  /// today + tomorrow based on the current preferences. Safe to call
  /// repeatedly — no duplicate IDs ever land.
  Future<void> rescheduleAll() async {
    if (!_initialized) {
      AppLog.w('⚠️ rescheduleAll() called before init()');
      return;
    }
    try {
      await _cancelAll();

      final today = _prayerTimesRepository.computeForToday();
      final tomorrow = _prayerTimesRepository
          .computeForDate(DateTime.now().add(const Duration(days: 1)));
      if (today == null) {
        AppLog.d(
            '⚠️ Reschedule skipped — no coordinates / computation failed');
        return;
      }

      final settings = _prayerNotificationPreferences.settings;
      final scheduled = <String>[];

      for (final prayer in PrayerName.values) {
        if (prayer == PrayerName.sunrise) continue;
        if (!settings.isEnabled(prayer)) continue;

        await _scheduleFor(
          prayer: prayer,
          times: today,
          dayOffset: 0,
          leadTime: settings.leadTime,
          scheduled: scheduled,
        );
        if (tomorrow != null) {
          await _scheduleFor(
            prayer: prayer,
            times: tomorrow,
            dayOffset: 1,
            leadTime: settings.leadTime,
            scheduled: scheduled,
          );
        }
      }

      AppLog.i('✅ Prayer notifications scheduled: ${scheduled.join(', ')}');
    } catch (e, s) {
      AppLog.e('❌ rescheduleAll failed', error: e, stackTrace: s);
    }
  }

  Future<void> _scheduleFor({
    required PrayerName prayer,
    required DailyPrayerTimes times,
    required int dayOffset,
    required PrayerNotificationLeadTime leadTime,
    required List<String> scheduled,
  }) async {
    final prayerTime = times.timeOf(prayer);
    final fireAt = prayerTime.subtract(Duration(minutes: leadTime.minutes));
    final now = DateTime.now();
    if (!fireAt.isAfter(now)) return;

    final tzFireAt = tz.TZDateTime.from(fireAt, tz.local);
    final id = _notificationId(prayer, dayOffset);
    final name = prayer.localizedName;
    final body = leadTime == PrayerNotificationLeadTime.instantly
        ? Strings.prayerNotificationBodyNow(name)
        : Strings.prayerNotificationBody(name);

    await _plugin.zonedSchedule(
      id,
      Strings.prayerNotificationTitle,
      body,
      tzFireAt,
      _platformDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: 'prayer:${prayer.name}',
    );
    scheduled.add('${prayer.name}+$dayOffset@${tzFireAt.toIso8601String()}');
  }

  Future<void> _cancelAll() async {
    for (final prayer in PrayerName.values) {
      if (prayer == PrayerName.sunrise) continue;
      await _plugin.cancel(_notificationId(prayer, 0));
      await _plugin.cancel(_notificationId(prayer, 1));
    }
  }

  /// Stable per-prayer + per-day-offset notification ID. The two-day
  /// window means we need 5 prayers × 2 offsets = 10 unique IDs.
  int _notificationId(PrayerName prayer, int dayOffset) {
    return _idBase + prayer.index * 2 + dayOffset;
  }

  NotificationDetails _platformDetails() {
    const android = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      enableVibration: true,
      playSound: true,
    );
    const ios = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    return const NotificationDetails(android: android, iOS: ios);
  }
}
