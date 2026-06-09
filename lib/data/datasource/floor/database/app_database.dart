import 'dart:async';

import 'package:koreaislam/core/log/logger/app_log.dart';
import 'package:koreaislam/data/datasource/floor/dao/attached_child_dao.dart';
import 'package:koreaislam/data/datasource/floor/dao/employee_entity_dao.dart';
import 'package:koreaislam/data/datasource/floor/dao/group_entity_dao.dart';
import 'package:koreaislam/data/datasource/floor/dao/parent_entity_dao.dart';
import 'package:koreaislam/data/datasource/floor/dao/prayer_log_dao.dart';
import 'package:koreaislam/data/datasource/floor/dao/student_entity_dao.dart';
import 'package:koreaislam/data/datasource/floor/dao/tenant_entity_dao.dart';
import 'package:koreaislam/data/datasource/floor/dao/user_entity_dao.dart';
import 'package:koreaislam/data/datasource/floor/database/callback.dart';
import 'package:koreaislam/data/datasource/floor/database/migrations.dart';
import 'package:koreaislam/data/datasource/floor/entities/attached_child_entity.dart';
import 'package:koreaislam/data/datasource/floor/entities/employee_entity.dart';
import 'package:koreaislam/data/datasource/floor/entities/group_entity.dart';
import 'package:koreaislam/data/datasource/floor/entities/parent_entity.dart';
import 'package:koreaislam/data/datasource/floor/entities/prayer_log_entity.dart';
import 'package:koreaislam/data/datasource/floor/entities/student_entity.dart';
import 'package:koreaislam/data/datasource/floor/entities/tenant_entity.dart';
import 'package:koreaislam/data/datasource/floor/entities/user_entity.dart';
import 'package:floor/floor.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart' as sqflite;

part 'app_database.g.dart';

@Database(
  entities: [
    GroupEntity,
    TenantEntity,
    UserEntity,
    StudentEntity,
    ParentEntity,
    EmployeeEntity,
    AttachedChildEntity,
    PrayerLogEntity,
  ],
  version: AppDatabase._schemaVersion,
)
abstract class AppDatabase extends FloorDatabase {
  static const int _schemaVersion = 8;
  static const String _databaseName = "app_database.db";

  GroupEntityDao get groupEntityDao;
  ParentEntityDao get parentEntityDao;
  StudentEntityDao get studentEntityDao;
  TenantEntityDao get tenantEntityDao;
  UserEntityDao get userEntityDao;
  AttachedChildDao get attachedChildDao;
  EmployeeEntityDao get employeeEntityDao;
  PrayerLogDao get prayerLogDao;

  static Future<AppDatabase> initializeDatabase() async {
    try {
      final database = await $FloorAppDatabase
          .databaseBuilder(_databaseName)
          .addCallback(databaseCallback)
          .addMigrations([
            migration1to2,
            migration5to6,
            migration6to7,
            migration7to8,
          ])
          .build();

      return database;
    } catch (e) {
      AppLog.e("❌ Database initialization failed: $e");
      final dbPath = await sqflite.getDatabasesPath();
      final path = p.join(dbPath, _databaseName);
      await sqflite.deleteDatabase(path);

      AppLog.w("⚠️ Deleted corrupted database at $path");

      return await $FloorAppDatabase
          .databaseBuilder(_databaseName)
          .addCallback(databaseCallback)
          .build();
    }
  }


}
