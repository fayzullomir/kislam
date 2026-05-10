import 'package:adhan_dart/adhan_dart.dart' as adhan;
import 'package:koreaislam/core/log/logger/app_log.dart';
import 'package:koreaislam/data/datasource/preference/calculation_method_preferences.dart';
import 'package:koreaislam/data/datasource/preference/location_preferences.dart';
import 'package:koreaislam/data/datasource/preference/madhab_preferences.dart';
import 'package:koreaislam/domain/models/madhab/madhab.dart';
import 'package:koreaislam/domain/models/prayer/daily_prayer_times.dart';

/// Pure-Dart prayer-time computation backed by [adhan_dart]. Reads the
/// user's selected coordinates / madhab / calculation method from the
/// preference singletons and returns [DailyPrayerTimes] in **local**
/// time (the library returns UTC; we convert here).
///
/// The repo is stateless — every call recomputes. Computation is fast
/// (sub-millisecond) so caching isn't needed; the home cubit caches the
/// last result for the day instead.
class PrayerTimesRepository {
  final LocationPreferences _locationPreferences;
  final MadhabPreferences _madhabPreferences;
  final CalculationMethodPreferences _calculationMethodPreferences;

  PrayerTimesRepository(
    this._locationPreferences,
    this._madhabPreferences,
    this._calculationMethodPreferences,
  );

  /// Compute prayer times for [date] using the currently-saved
  /// preferences. Returns null when coordinates aren't available — the
  /// caller (home cubit / scheduler) shows an empty / "set location"
  /// state instead of crashing.
  DailyPrayerTimes? computeForDate(DateTime date) {
    final location = _locationPreferences.location;
    final lat = location.latitude;
    final lng = location.longitude;
    if (lat == null || lng == null) {
      AppLog.d('⚠️ Prayer times skipped — no GPS coordinates saved');
      return null;
    }

    try {
      final coordinates = adhan.Coordinates(lat, lng);
      final params = _calculationMethodPreferences.method.adhanParameters;
      params.madhab = _toAdhanMadhab(_madhabPreferences.madhab);

      // adhan_dart computes around midnight UTC of the given date — we
      // pass the local-midnight equivalent so today's times line up
      // with the user's wall clock.
      final dayStart = DateTime(date.year, date.month, date.day);
      final times = adhan.PrayerTimes(
        date: dayStart,
        coordinates: coordinates,
        calculationParameters: params,
      );

      return DailyPrayerTimes(
        date: dayStart,
        fajr: times.fajr.toLocal(),
        sunrise: times.sunrise.toLocal(),
        dhuhr: times.dhuhr.toLocal(),
        asr: times.asr.toLocal(),
        maghrib: times.maghrib.toLocal(),
        isha: times.isha.toLocal(),
        fajrTomorrow: times.fajrAfter.toLocal(),
      );
    } catch (e, s) {
      AppLog.e('❌ Prayer times computation failed', error: e, stackTrace: s);
      return null;
    }
  }

  /// Today's prayer times — convenience wrapper over [computeForDate].
  DailyPrayerTimes? computeForToday() => computeForDate(DateTime.now());

  /// adhan_dart only knows two madhabs (shafi / hanafi); Maliki and
  /// Hanbali use the same Asr-shadow rule as Shafi (1× shadow length),
  /// so we map them onto [adhan.Madhab.shafi].
  adhan.Madhab _toAdhanMadhab(Madhab madhab) {
    switch (madhab) {
      case Madhab.hanafi:
        return adhan.Madhab.hanafi;
      case Madhab.shafii:
      case Madhab.maliki:
      case Madhab.hanbali:
        return adhan.Madhab.shafi;
    }
  }
}
