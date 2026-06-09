import 'package:floor/floor.dart';

@Entity(
  tableName: "prayer_log",
  indices: [
    Index(value: ["log_date", "log_prayer"], unique: true),
  ],
)
class PrayerLogEntity {
  @PrimaryKey(autoGenerate: true)
  @ColumnInfo(name: "log_id")
  int? id;

  @ColumnInfo(name: "log_date")
  String date;

  @ColumnInfo(name: "log_prayer")
  String prayer;

  @ColumnInfo(name: "log_status")
  String status;

  PrayerLogEntity({
    this.id,
    required this.date,
    required this.prayer,
    required this.status,
  });
}
