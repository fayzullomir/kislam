import 'package:floor/floor.dart';
import 'package:koreaislam/core/log/logger/app_log.dart';

Callback get databaseCallback => Callback(onCreate: (database, version) {
      // Called when the database is created for the first time.
    }, onUpgrade: (database, startVersion, endVersion) async {
      AppLog.i("onUpgrade: $startVersion, $endVersion");
      // Called when the database needs to be upgraded.
    }, onOpen: (database) async {
      // Called when the database has been opened.
      AppLog.i("onOpen");
    });
