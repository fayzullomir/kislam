import 'package:koreaislam/presentation/application/di/get_it_module_cubit.dart';
import 'package:koreaislam/presentation/application/di/get_it_module_database.dart';
import 'package:koreaislam/presentation/application/di/get_it_module_network.dart';
import 'package:koreaislam/presentation/application/di/get_it_module_preference.dart';
import 'package:koreaislam/presentation/application/di/get_it_module_repository.dart';
import 'package:koreaislam/presentation/application/di/get_it_module_channel.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> initializeGetIt() async {
  await _initializeGetIt();
}

Future<void> _initializeGetIt() async {
  await GetIt.instance.preferencesModule();
  await GetIt.instance.databaseModule();
  await GetIt.instance.channelModule();
  await GetIt.instance.networkModule();
  await GetIt.instance.repositoryModule();
  await GetIt.instance.appModule();

  await GetIt.instance.allReady();
}
