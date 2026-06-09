import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:koreaislam/data/datasource/preference/location_preferences.dart';
import 'package:koreaislam/data/repositories/prayer_times/prayer_times_repository.dart';
import 'package:koreaislam/domain/models/prayer/daily_prayer_times.dart';
import 'package:koreaislam/presentation/support/cubit/base_cubit.dart';

part 'monthly_prayer_times_cubit.freezed.dart';
part 'monthly_prayer_times_state.dart';

/// Monthly prayer-time calendar.
///
/// Computes the five obligatory prayers plus sunrise for every day of the
/// visible month via [PrayerTimesRepository], honouring the user's saved
/// location, madhab, and calculation method. Recomputes on month change.
@injectable
class MonthlyPrayerTimesCubit
    extends BaseCubit<MonthlyPrayerTimesState, MonthlyPrayerTimesEvent> {
  final PrayerTimesRepository _prayerTimesRepository;
  final LocationPreferences _locationPreferences;

  MonthlyPrayerTimesCubit(
    this._prayerTimesRepository,
    this._locationPreferences,
  ) : super(MonthlyPrayerTimesState(month: _firstOfCurrentMonth())) {
    _load();
  }

  static DateTime _firstOfCurrentMonth() {
    final now = DateTime.now();
    return DateTime(now.year, now.month);
  }

  void previousMonth() {
    updateState((s) => s.copyWith(
          month: DateTime(s.month.year, s.month.month - 1),
        ));
    _load();
  }

  void nextMonth() {
    updateState((s) => s.copyWith(
          month: DateTime(s.month.year, s.month.month + 1),
        ));
    _load();
  }

  void _load() {
    final month = states.month;
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final days = <DailyPrayerTimes?>[
      for (var day = 1; day <= daysInMonth; day++)
        _prayerTimesRepository.computeForDate(DateTime(month.year, month.month, day)),
    ];

    final location = _locationPreferences.location;
    updateState((s) => s.copyWith(
          days: days,
          city: _resolveCity(location.city, location.country),
        ));
  }

  String _resolveCity(String? city, String? country) {
    if (city != null && city.isNotEmpty) return city;
    if (country != null && country.isNotEmpty) return country;
    return '';
  }
}
