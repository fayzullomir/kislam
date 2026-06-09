import 'package:koreaislam/data/datasource/floor/dao/prayer_log_dao.dart';
import 'package:koreaislam/data/datasource/floor/entities/prayer_log_entity.dart';
import 'package:koreaislam/domain/models/prayer/prayer_log.dart';
import 'package:koreaislam/domain/models/prayer/prayer_log_status.dart';
import 'package:koreaislam/domain/models/prayer/prayer_log_type.dart';

/// Persistence for the Qada Tracker journal, backed by Floor.
///
/// One `prayer_log` row per (day, prayer) records how it was performed.
/// All qada counts are derived from these entries by the cubit.
class PrayerLogRepository {
  final PrayerLogDao _dao;

  PrayerLogRepository(this._dao);

  Future<List<PrayerLog>> getLogs() async {
    final rows = await _dao.getAllLogs();
    return rows
        .map((row) {
          final status = PrayerLogStatus.fromStorageKey(row.status);
          if (status == null) return null;
          return PrayerLog(
            date: row.date,
            prayer: PrayerLogType.fromStorageKey(row.prayer),
            status: status,
          );
        })
        .whereType<PrayerLog>()
        .toList();
  }

  Future<void> setStatus({
    required String date,
    required PrayerLogType prayer,
    required PrayerLogStatus status,
  }) {
    return _dao.upsertLog(PrayerLogEntity(
      date: date,
      prayer: prayer.storageKey,
      status: status.storageKey,
    ));
  }

  Future<void> clearStatus({
    required String date,
    required PrayerLogType prayer,
  }) {
    return _dao.deleteLog(date, prayer.storageKey);
  }
}
