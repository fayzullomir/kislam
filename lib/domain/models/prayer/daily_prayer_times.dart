import 'package:koreaislam/domain/models/prayer/prayer_name.dart';

/// The five obligatory prayers (plus sunrise) computed for a single day,
/// in **local** time. [adhan_dart] returns UTC DateTimes; the repository
/// converts them with `.toLocal()` before constructing this model so the
/// UI can format them directly without further conversion.
class DailyPrayerTimes {
  /// Calendar day these times belong to (00:00 local time, no offset
  /// arithmetic). Stored only for cache invalidation.
  final DateTime date;

  final DateTime fajr;
  final DateTime sunrise;
  final DateTime dhuhr;
  final DateTime asr;
  final DateTime maghrib;
  final DateTime isha;

  /// Tomorrow's Fajr — used to compute the home-page countdown when
  /// `now` is past today's Isha. Comes from the same [PrayerTimes]
  /// instance via the library's `fajrAfter` field.
  final DateTime fajrTomorrow;

  const DailyPrayerTimes({
    required this.date,
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.fajrTomorrow,
  });

  DateTime timeOf(PrayerName prayer) {
    switch (prayer) {
      case PrayerName.fajr:
        return fajr;
      case PrayerName.sunrise:
        return sunrise;
      case PrayerName.dhuhr:
        return dhuhr;
      case PrayerName.asr:
        return asr;
      case PrayerName.maghrib:
        return maghrib;
      case PrayerName.isha:
        return isha;
    }
  }

  /// Returns the upcoming prayer + its DateTime relative to [now]. When
  /// today's Isha has passed, the next prayer is tomorrow's Fajr.
  ({PrayerName name, DateTime time}) nextPrayer(DateTime now) {
    if (now.isBefore(fajr)) return (name: PrayerName.fajr, time: fajr);
    if (now.isBefore(dhuhr)) return (name: PrayerName.dhuhr, time: dhuhr);
    if (now.isBefore(asr)) return (name: PrayerName.asr, time: asr);
    if (now.isBefore(maghrib)) {
      return (name: PrayerName.maghrib, time: maghrib);
    }
    if (now.isBefore(isha)) return (name: PrayerName.isha, time: isha);
    return (name: PrayerName.fajr, time: fajrTomorrow);
  }

  /// The five obligatory prayers in display order. Sunrise is omitted —
  /// the home page's prayer-times row only renders the obligatory five.
  List<({PrayerName name, DateTime time})> get obligatoryPrayers => [
        (name: PrayerName.fajr, time: fajr),
        (name: PrayerName.dhuhr, time: dhuhr),
        (name: PrayerName.asr, time: asr),
        (name: PrayerName.maghrib, time: maghrib),
        (name: PrayerName.isha, time: isha),
      ];
}
