part of 'monthly_prayer_times_cubit.dart';

@freezed
class MonthlyPrayerTimesState with _$MonthlyPrayerTimesState {
  const MonthlyPrayerTimesState._();

  const factory MonthlyPrayerTimesState({
    /// First day of the visible month.
    required DateTime month,

    /// Prayer times for each day of [month] (index 0 = day 1). A null entry
    /// means the times could not be computed (no saved location).
    @Default(<DailyPrayerTimes?>[]) List<DailyPrayerTimes?> days,

    /// City/country label for the header. Empty when no location is saved.
    @Default('') String city,
  }) = _MonthlyPrayerTimesState;

  bool get hasLocation => days.any((d) => d != null);

  /// 1-based day-of-month considered "today", or null when the visible
  /// month is not the current calendar month.
  int? get todayDay {
    final now = DateTime.now();
    if (now.year != month.year || now.month != month.month) return null;
    return now.day;
  }
}

@freezed
class MonthlyPrayerTimesEvent with _$MonthlyPrayerTimesEvent {
  const factory MonthlyPrayerTimesEvent() = _MonthlyPrayerTimesEvent;
}
