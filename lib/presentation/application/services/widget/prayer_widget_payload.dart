import 'package:koreaislam/domain/models/prayer/daily_prayer_times.dart';

/// Serializable snapshot handed to the native home-screen widgets. The
/// Flutter side computes everything (localized labels, location label,
/// two days of times) so the native renderers stay dumb — they only read
/// this payload and draw.
class PrayerWidgetPayload {
  static const int version = 1;

  final String language;
  final String? locationLabel;
  final int generatedAt;
  final Map<String, String> labels;
  final List<PrayerWidgetDay> days;

  const PrayerWidgetPayload({
    required this.language,
    required this.locationLabel,
    required this.generatedAt,
    required this.labels,
    required this.days,
  });

  Map<String, dynamic> toJson() => {
        'version': version,
        'language': language,
        'locationLabel': locationLabel,
        'generatedAt': generatedAt,
        'labels': labels,
        'days': days.map((d) => d.toJson()).toList(),
      };
}

/// One day's six times as absolute epoch milliseconds. Native formats the
/// wall-clock `HH:mm` from these in the device's local timezone and picks
/// the active / next prayer by comparing against `now`.
class PrayerWidgetDay {
  final String date;
  final int fajr;
  final int sunrise;
  final int dhuhr;
  final int asr;
  final int maghrib;
  final int isha;

  const PrayerWidgetDay({
    required this.date,
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
  });

  factory PrayerWidgetDay.fromTimes(DailyPrayerTimes times) {
    final d = times.date;
    final dateStr = '${d.year.toString().padLeft(4, '0')}-'
        '${d.month.toString().padLeft(2, '0')}-'
        '${d.day.toString().padLeft(2, '0')}';
    return PrayerWidgetDay(
      date: dateStr,
      fajr: times.fajr.millisecondsSinceEpoch,
      sunrise: times.sunrise.millisecondsSinceEpoch,
      dhuhr: times.dhuhr.millisecondsSinceEpoch,
      asr: times.asr.millisecondsSinceEpoch,
      maghrib: times.maghrib.millisecondsSinceEpoch,
      isha: times.isha.millisecondsSinceEpoch,
    );
  }

  Map<String, dynamic> toJson() => {
        'date': date,
        'fajr': fajr,
        'sunrise': sunrise,
        'dhuhr': dhuhr,
        'asr': asr,
        'maghrib': maghrib,
        'isha': isha,
      };
}
