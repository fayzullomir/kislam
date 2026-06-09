/// How a tracked prayer was performed on a given day. The first three
/// count as "made up" (they reduce the qada backlog); [missed] is recorded
/// for the journal but counts as an outstanding qada.
enum PrayerLogStatus {
  jamoat,
  onTime,
  late,
  missed;

  String get storageKey => name;

  /// Whether this status counts as the prayer being performed.
  bool get isPrayed => this != PrayerLogStatus.missed;

  static PrayerLogStatus? fromStorageKey(String? key) {
    if (key == null) return null;
    for (final status in PrayerLogStatus.values) {
      if (status.storageKey == key) return status;
    }
    return null;
  }
}
