import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
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
  bool _listenersWired = false;

  // TEMP diagnostics — release-visible trail surfaced in the notification sheet.
  final ValueNotifier<List<String>> diagnostics =
      ValueNotifier<List<String>>(<String>[]);

  void _trace(String line) {
    final ts = DateTime.now().toIso8601String().substring(11, 19);
    diagnostics.value = [...diagnostics.value, '$ts  $line'];
    AppLog.d('[PrayerDiag] $line');
  }

  Future<void> _tracePermissions() async {
    if (!Platform.isAndroid) return;
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android == null) {
      _trace('perm: android impl == null');
      return;
    }
    try {
      final enabled = await android.areNotificationsEnabled();
      final canExact = await android.canScheduleExactNotifications();
      _trace('perm: notifEnabled=$enabled canExact=$canExact');
    } catch (e) {
      _trace('perm check failed: $e');
    }
  }

  /// One-shot setup: load the timezone database, tell `tz` which zone
  /// the device is in, pre-create the Android channel, and request the
  /// runtime permissions zonedSchedule needs (POST_NOTIFICATIONS on
  /// Android 13+, SCHEDULE_EXACT_ALARM on Android 14+). Must run before
  /// any `zonedSchedule` call.
  ///
  /// Safe to call repeatedly — partial failures are isolated so a
  /// timezone hiccup doesn't block channel creation, and the listener
  /// wiring runs even when init has to fall back to UTC.
  Future<void> init() async {
    if (_initialized) return;
    try {
      await _initializeTimezone();
      await _ensureAndroidChannel();
      await _requestAndroidPermissions();
      _initialized = true;
      _trace('init ok (tz=${tz.local.name})');
      await _tracePermissions();
      AppLog.i('✅ Prayer scheduler initialized (tz=${tz.local.name})');
    } catch (e, s) {
      _trace('init FAILED: $e');
      AppLog.e('❌ Prayer scheduler init failed', error: e, stackTrace: s);
      _recordToCrashlytics(e, s, reason: 'PrayerScheduler.init');
      // Mark initialized anyway — the fallback UTC zone keeps tz.local
      // usable and we don't want to permanently block scheduling because
      // a single sub-step threw.
      _initialized = true;
    } finally {
      _wireListenersOnce();
    }
  }

  /// Best-effort timezone setup. `flutter_timezone` usually returns an
  /// IANA name like `Asia/Seoul`, but some Samsung/Xiaomi ROMs return
  /// short forms (`KST`, `MSK`) that the bundled IANA database doesn't
  /// know about. In that case we fall back to UTC so `tz.local` stays
  /// usable — `TZDateTime.from(dt, tz.local)` preserves the absolute
  /// instant either way, so the user still gets a notification at the
  /// correct wall-clock minute.
  Future<void> _initializeTimezone() async {
    tz_data.initializeTimeZones();
    // Seed a known-good default first so any failure below still leaves
    // tz.local pointing somewhere valid.
    tz.setLocalLocation(tz.UTC);
    String? localName;
    try {
      localName = await FlutterTimezone.getLocalTimezone();
    } catch (e, s) {
      AppLog.e(
        '❌ FlutterTimezone.getLocalTimezone failed — staying on UTC',
        error: e,
        stackTrace: s,
      );
      _recordToCrashlytics(e, s,
          reason: 'PrayerScheduler.FlutterTimezone.getLocalTimezone');
      return;
    }
    try {
      tz.setLocalLocation(tz.getLocation(localName));
    } catch (e, s) {
      AppLog.e(
        '❌ tz.getLocation failed for "$localName" — staying on UTC',
        error: e,
        stackTrace: s,
      );
      _recordToCrashlytics(e, s,
          reason: 'PrayerScheduler.tz.getLocation("$localName")');
    }
  }

  /// Pre-create the Android notification channel so the very first
  /// scheduled notification has somewhere to land. Without this, on
  /// Android 8+ a malformed schedule can drop the notification silently
  /// because the OS rejects channels that don't exist yet.
  Future<void> _ensureAndroidChannel() async {
    if (!Platform.isAndroid) return;
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android == null) return;
    try {
      await android.createNotificationChannel(
        const AndroidNotificationChannel(
          _channelId,
          _channelName,
          description: _channelDescription,
          importance: Importance.high,
          enableVibration: true,
          playSound: true,
        ),
      );
    } catch (e, s) {
      AppLog.e('❌ createNotificationChannel failed',
          error: e, stackTrace: s);
      _recordToCrashlytics(e, s,
          reason: 'PrayerScheduler.createNotificationChannel');
    }
  }

  /// Belt-and-braces permission request — the onboarding `PermissionsPage`
  /// already asks for `Permission.notification`, but on Android 14+
  /// `SCHEDULE_EXACT_ALARM` needs a separate runtime grant, and an
  /// upgrade from an older app version may bypass the onboarding flow
  /// entirely (so POST_NOTIFICATIONS is still ungranted). Asking again
  /// here is a no-op when permission already exists.
  Future<void> _requestAndroidPermissions() async {
    if (!Platform.isAndroid) return;
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android == null) return;
    try {
      await android.requestNotificationsPermission();
    } catch (e, s) {
      AppLog.e('❌ requestNotificationsPermission failed',
          error: e, stackTrace: s);
      _recordToCrashlytics(e, s,
          reason: 'PrayerScheduler.requestNotificationsPermission');
    }
    try {
      await android.requestExactAlarmsPermission();
    } catch (e, s) {
      AppLog.e('❌ requestExactAlarmsPermission failed',
          error: e, stackTrace: s);
      _recordToCrashlytics(e, s,
          reason: 'PrayerScheduler.requestExactAlarmsPermission');
    }
  }

  /// Listens to every preference that affects the schedule. Any change
  /// triggers a reschedule so the next reminder always reflects the
  /// latest user choice.
  void _wireListenersOnce() {
    if (_listenersWired) return;
    _listenersWired = true;
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
      AppLog.w('⚠️ rescheduleAll() before init() — running init first');
      await init();
    }
    try {
      diagnostics.value = <String>[];
      _trace('reschedule start');
      await _tracePermissions();
      await _cancelAll();

      final today = _prayerTimesRepository.computeForToday();
      final tomorrow = _prayerTimesRepository
          .computeForDate(DateTime.now().add(const Duration(days: 1)));
      if (today == null) {
        _trace('SKIPPED — today == null (no coords / compute failed)');
        AppLog.d(
            '⚠️ Reschedule skipped — no coordinates / computation failed');
        return;
      }

      final settings = _prayerNotificationPreferences.settings;
      _trace('lead=${settings.leadTime.minutes}m tomorrow=${tomorrow != null}');
      final scheduled = <String>[];

      for (final prayer in PrayerName.values) {
        if (prayer == PrayerName.sunrise) continue;
        if (!settings.isEnabled(prayer)) {
          _trace('${prayer.name}: disabled');
          continue;
        }

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

      _trace('done — ${scheduled.length} scheduled');
      AppLog.i('✅ Prayer notifications scheduled: ${scheduled.join(', ')}');
    } catch (e, s) {
      _trace('reschedule FAILED: $e');
      AppLog.e('❌ rescheduleAll failed', error: e, stackTrace: s);
      _recordToCrashlytics(e, s, reason: 'PrayerScheduler.rescheduleAll');
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
    if (!fireAt.isAfter(now)) {
      _trace('${prayer.name}+$dayOffset: past (${fireAt.toIso8601String()})');
      return;
    }

    final tzFireAt = tz.TZDateTime.from(fireAt, tz.local);
    final id = _notificationId(prayer, dayOffset);
    final name = prayer.localizedName;
    final body = leadTime == PrayerNotificationLeadTime.instantly
        ? Strings.prayerNotificationBodyNow(name)
        : Strings.prayerNotificationBody(name);

    // Try the exact-allow-while-idle mode first (most reliable). If the
    // OS denies it (Android 14+ without SCHEDULE_EXACT_ALARM grant),
    // fall back to the inexact mode so the user still gets a reminder
    // — even if it's a few minutes off.
    try {
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
      _trace('${prayer.name}+$dayOffset: EXACT @ ${tzFireAt.toIso8601String()}');
    } catch (e, s) {
      _trace('${prayer.name}+$dayOffset: exact denied → inexact ($e)');
      AppLog.w(
        '⚠️ exactAllowWhileIdle denied — retrying with inexact mode',
        error: e,
        stackTrace: s,
      );
      await _plugin.zonedSchedule(
        id,
        Strings.prayerNotificationTitle,
        body,
        tzFireAt,
        _platformDetails(),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: 'prayer:${prayer.name}',
      );
      _trace('${prayer.name}+$dayOffset: INEXACT @ ${tzFireAt.toIso8601String()}');
    }
    scheduled.add('${prayer.name}+$dayOffset@${tzFireAt.toIso8601String()}');
  }

  // TEMP diagnostics — fires an immediate notification and one 10s out to
  // separate "scheduling broken" from "delivery broken" in release.
  Future<void> fireTestNotification() async {
    await init();
    try {
      await _plugin.show(
        99999,
        'Test (now)',
        'Immediate notification',
        _platformDetails(),
      );
      _trace('test: show() called');
    } catch (e) {
      _trace('test show FAILED: $e');
    }
    try {
      final at = tz.TZDateTime.now(tz.local).add(const Duration(seconds: 10));
      await _plugin.zonedSchedule(
        99998,
        'Test (+10s)',
        'Scheduled notification',
        at,
        _platformDetails(),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
      _trace('test: scheduled +10s @ ${at.toIso8601String()}');
    } catch (e) {
      _trace('test schedule FAILED: $e');
    }
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

  /// AppLog is silenced in release (Level.off), which hid the real
  /// cause of "notifications don't fire" on shipped APKs. Forwarding
  /// the same error to Crashlytics gives us a release-visible trail
  /// without changing the dev-time log output.
  void _recordToCrashlytics(Object error, StackTrace stack,
      {required String reason}) {
    try {
      FirebaseCrashlytics.instance.recordError(
        error,
        stack,
        reason: reason,
        fatal: false,
      );
    } catch (_) {
      // Crashlytics may not be initialized yet during very early app
      // startup — swallow because the AppLog above already captured it.
    }
  }
}
