import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart';

final migration1to2 = Migration(1, 2, (database) async {
  await database.execute('''
    CREATE TABLE IF NOT EXISTS tenant (
      tenant_id INTEGER PRIMARY KEY AUTOINCREMENT,
      tenant_tenant_id INTEGER NOT NULL,
      tenant_name TEXT NOT NULL,
      tenant_description TEXT NOT NULL,
      tenant_latitude REAL NOT NULL,
      tenant_longitude REAL NOT NULL,
      tenant_allowed_radius REAL NOT NULL,
      tenant_type TEXT NOT NULL,
      tenant_address TEXT NOT NULL,
      tenant_region_id INTEGER NOT NULL,
      tenant_region_name TEXT NOT NULL,
      tenant_district_id INTEGER NOT NULL,
      tenant_district_name TEXT NOT NULL,
      tenant_photo_path TEXT NOT NULL,
      tenant_student_count INTEGER NOT NULL,
      tenant_group_count INTEGER NOT NULL,
      tenant_employee_count INTEGER NOT NULL,
      tenant_created_at TEXT NOT NULL,
      tenant_updated_at TEXT NOT NULL
    );
  ''');
});

/// Idempotent Qada Tracker schema: drops any legacy `qazo_*` tables (early
/// dev builds at v6/v7) and (re)creates `prayer_log`. Reused by every
/// migration step that can reach the Qada Tracker schema so a device at any
/// prior version converges to the same state.
Future<void> _ensurePrayerLogSchema(DatabaseExecutor database) async {
  await database.execute('DROP TABLE IF EXISTS qazo_prayer;');
  await database.execute('DROP TABLE IF EXISTS qazo_log;');
  await database.execute('''
    CREATE TABLE IF NOT EXISTS prayer_log (
      log_id INTEGER PRIMARY KEY AUTOINCREMENT,
      log_date TEXT NOT NULL,
      log_prayer TEXT NOT NULL,
      log_status TEXT NOT NULL
    );
  ''');
  await database.execute('''
    CREATE UNIQUE INDEX IF NOT EXISTS index_prayer_log_log_date_log_prayer
    ON prayer_log (log_date, log_prayer);
  ''');
}

final migration5to6 = Migration(5, 6, _ensurePrayerLogSchema);
final migration6to7 = Migration(6, 7, _ensurePrayerLogSchema);
final migration7to8 = Migration(7, 8, _ensurePrayerLogSchema);

// final migration4to5 = Migration(4, 5, (database) async {
//   await database.execute('''
//     CREATE TABLE IF NOT EXISTS employees (
//       id INTEGER PRIMARY KEY,
//       firstName TEXT,
//       lastName TEXT,
//       iin TEXT,
//       role INTEGER,
//       position INTEGER,
//       email TEXT,
//       photoPath TEXT,
//       organizationId INTEGER,
//       organizationName TEXT,
//       organizationDescription TEXT
//     )
//   ''');
// });
