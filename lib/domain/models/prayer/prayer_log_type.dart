/// The six prayers tracked in the Qada Tracker: the five obligatory
/// prayers plus Witr. Each carries its rakat count and a stable storage
/// key persisted in the prayer-log table.
enum PrayerLogType {
  fajr(rakat: 2),
  dhuhr(rakat: 4),
  asr(rakat: 4),
  maghrib(rakat: 3),
  isha(rakat: 4),
  vitr(rakat: 3);

  final int rakat;

  const PrayerLogType({required this.rakat});

  String get storageKey => name;

  static PrayerLogType fromStorageKey(String key) =>
      PrayerLogType.values.firstWhere((p) => p.storageKey == key);
}
