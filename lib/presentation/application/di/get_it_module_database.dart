import 'package:koreaislam/data/datasource/floor/dao/attached_child_dao.dart';
import 'package:koreaislam/data/datasource/floor/dao/employee_entity_dao.dart';
import 'package:koreaislam/data/datasource/floor/dao/group_entity_dao.dart';
import 'package:koreaislam/data/datasource/floor/dao/parent_entity_dao.dart';
import 'package:koreaislam/data/datasource/floor/dao/prayer_log_dao.dart';
import 'package:koreaislam/data/datasource/floor/dao/student_entity_dao.dart';
import 'package:koreaislam/data/datasource/floor/dao/tenant_entity_dao.dart';
import 'package:koreaislam/data/datasource/floor/dao/user_entity_dao.dart';
import 'package:koreaislam/data/datasource/floor/database/app_database.dart';
import 'package:get_it/get_it.dart';

extension GetItModuleDatabase on GetIt {
  Future<void> databaseModule() async {
    registerSingletonAsync<AppDatabase>(
      () async => await AppDatabase.initializeDatabase(),
    );

    registerSingletonWithDependencies<GroupEntityDao>(
      () => get<AppDatabase>().groupEntityDao,
      dependsOn: [AppDatabase],
    );
    registerSingletonWithDependencies<TenantEntityDao>(
      () => get<AppDatabase>().tenantEntityDao,
      dependsOn: [AppDatabase],
    );
    registerSingletonWithDependencies<UserEntityDao>(
      () => get<AppDatabase>().userEntityDao,
      dependsOn: [AppDatabase],
    );

    registerSingletonWithDependencies<StudentEntityDao>(
          () => get<AppDatabase>().studentEntityDao,
      dependsOn: [AppDatabase],
    );
    registerSingletonWithDependencies<ParentEntityDao>(
          () => get<AppDatabase>().parentEntityDao,
      dependsOn: [AppDatabase],
    );
    registerSingletonWithDependencies<AttachedChildDao>(
          () => get<AppDatabase>().attachedChildDao,
      dependsOn: [AppDatabase],
    );

    registerSingletonWithDependencies<EmployeeEntityDao>(
          () => get<AppDatabase>().employeeEntityDao,
      dependsOn: [AppDatabase],
    );

    registerSingletonWithDependencies<PrayerLogDao>(
      () => get<AppDatabase>().prayerLogDao,
      dependsOn: [AppDatabase],
    );

    await allReady();
  }
}
