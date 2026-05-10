/// How far in advance a prayer notification is fired. Persisted as a
/// string-name in [PrayerNotificationPreferences].
enum PrayerNotificationLeadTime {
  /// Fire the notification at the prayer time itself.
  instantly(0),

  /// Fire 5 minutes before the prayer.
  fiveMinutesBefore(5),

  /// Fire 10 minutes before the prayer.
  tenMinutesBefore(10);

  /// Lead in minutes before the prayer time. Used by the scheduler when
  /// computing the notification trigger from the prayer DateTime.
  final int minutes;

  const PrayerNotificationLeadTime(this.minutes);

  static PrayerNotificationLeadTime valueOrDefault(String? name) {
    return PrayerNotificationLeadTime.values.firstWhere(
      (e) => e.name.toLowerCase() == name?.toLowerCase(),
      orElse: () => defaultLeadTime,
    );
  }

  static PrayerNotificationLeadTime get defaultLeadTime =>
      PrayerNotificationLeadTime.tenMinutesBefore;
}
