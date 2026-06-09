part of 'qada_tracker_cubit.dart';

@freezed
class QadaTrackerState with _$QadaTrackerState {
  const QadaTrackerState._();

  const factory QadaTrackerState({
    required DateTime selectedDate,
    @Default(true) bool isLoading,

    /// Days rendered in the horizontal selector (oldest → newest).
    @Default(<DateTime>[]) List<DateTime> days,

    /// Full journal of how each prayer was logged per day. The qada counts
    /// are derived entirely from these entries.
    @Default(<PrayerLog>[]) List<PrayerLog> logs,
  }) = _QadaTrackerState;

  static final DateFormat _keyFormat = DateFormat('yyyy-MM-dd');

  String get _selectedKey => _keyFormat.format(selectedDate);

  /// Status logged for a prayer on the currently selected day, if any.
  PrayerLogStatus? statusFor(PrayerLogType prayer) {
    for (final log in logs) {
      if (log.date == _selectedKey && log.prayer == prayer) return log.status;
    }
    return null;
  }

  /// Number of times this prayer was logged as a qada (missed) across the
  /// whole journal.
  int missedFor(PrayerLogType prayer) =>
      logs.where((l) => l.prayer == prayer && !l.status.isPrayed).length;

  /// Total number of logged prayers (every entered record).
  int get totalLogged => logs.length;

  /// Total qada (missed) prayers — the headline "JAMI QOLDI" count.
  int get totalMissed => logs.where((l) => !l.status.isPrayed).length;

  /// Share of logged prayers that were missed (drives the progress bar).
  double get progress => totalLogged == 0 ? 0 : totalMissed / totalLogged;

  int get progressPercent => (progress * 100).round();

  bool isSelected(DateTime day) =>
      day.year == selectedDate.year &&
      day.month == selectedDate.month &&
      day.day == selectedDate.day;
}

@freezed
class QadaTrackerEvent with _$QadaTrackerEvent {
  const factory QadaTrackerEvent() = _QadaTrackerEvent;
}
