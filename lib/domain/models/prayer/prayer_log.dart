import 'package:koreaislam/domain/models/prayer/prayer_log_status.dart';
import 'package:koreaislam/domain/models/prayer/prayer_log_type.dart';

/// A single journal entry: how a given prayer was performed on a given day.
/// [date] is an ISO `yyyy-MM-dd` string (the key used in the prayer-log table).
class PrayerLog {
  final String date;
  final PrayerLogType prayer;
  final PrayerLogStatus status;

  const PrayerLog({
    required this.date,
    required this.prayer,
    required this.status,
  });
}
