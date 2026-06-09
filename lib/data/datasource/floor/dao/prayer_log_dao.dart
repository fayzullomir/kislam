import 'package:floor/floor.dart';
import 'package:koreaislam/data/datasource/floor/entities/prayer_log_entity.dart';

@dao
abstract class PrayerLogDao {
  @Query('SELECT * FROM prayer_log')
  Future<List<PrayerLogEntity>> getAllLogs();

  @Query('SELECT * FROM prayer_log')
  Stream<List<PrayerLogEntity>> watchAllLogs();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> upsertLog(PrayerLogEntity log);

  @Query('DELETE FROM prayer_log WHERE log_date = :date AND log_prayer = :prayer')
  Future<void> deleteLog(String date, String prayer);
}
