import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:koreaislam/data/repositories/prayer_log/prayer_log_repository.dart';
import 'package:koreaislam/domain/models/prayer/prayer_log.dart';
import 'package:koreaislam/domain/models/prayer/prayer_log_type.dart';
import 'package:koreaislam/domain/models/prayer/prayer_log_status.dart';
import 'package:koreaislam/presentation/support/cubit/base_cubit.dart';

part 'qada_tracker_cubit.freezed.dart';
part 'qada_tracker_state.dart';

/// Qada Tracker — missed-prayer make-up tracker.
///
/// Loads the full journal of how each prayer was performed per day. Marking
/// a prayer writes a log row; every qada count is derived from those logs
/// (see [QadaTrackerState]).
@injectable
class QadaTrackerCubit extends BaseCubit<QadaTrackerState, QadaTrackerEvent> {
  final PrayerLogRepository _repository;

  QadaTrackerCubit(this._repository) : super(QadaTrackerState(selectedDate: _today())) {
    init();
  }

  static final DateFormat _keyFormat = DateFormat('yyyy-MM-dd');

  static DateTime _today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  Future<void> init() async {
    updateState((s) => s.copyWith(isLoading: true, days: _buildDays()));
    await _reload();
    updateState((s) => s.copyWith(isLoading: false));
  }

  Future<void> _reload() async {
    final logs = await _repository.getLogs();
    updateState((s) => s.copyWith(logs: logs));
  }

  void selectDate(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);
    if (normalized.isAfter(_today())) return;
    updateState((s) => s.copyWith(selectedDate: normalized));
  }

  /// Applies [status] to [prayer] on the selected day. Tapping the already
  /// selected status clears it (toggle off).
  Future<void> setStatus(PrayerLogType prayer, PrayerLogStatus status) async {
    final dateKey = _keyFormat.format(states.selectedDate);
    final current = states.statusFor(prayer);
    if (current == status) {
      await _repository.clearStatus(date: dateKey, prayer: prayer);
    } else {
      await _repository.setStatus(
        date: dateKey,
        prayer: prayer,
        status: status,
      );
    }
    await _reload();
  }

  /// 34-day window ending three days in the future so a few upcoming days
  /// render (disabled) after today, matching the design's day strip.
  List<DateTime> _buildDays() {
    final today = _today();
    return List.generate(34, (i) => today.subtract(Duration(days: 30 - i)));
  }
}
