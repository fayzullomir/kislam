/// The five daily obligatory prayers plus sunrise. We mirror only what the
/// home page and notification scheduler need — the underlying [adhan_dart]
/// `Prayer` enum has additional values (ishaBefore, fajrAfter) used for
/// edge cases that we don't surface in the UI.
enum PrayerName {
  fajr,
  sunrise,
  dhuhr,
  asr,
  maghrib,
  isha;
}
