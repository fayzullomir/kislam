import 'package:get_it/get_it.dart';
import 'package:koreaislam/domain/channels/app_theme_mode_channel.dart';
import 'package:koreaislam/domain/channels/country_selection_channel.dart';
import 'package:koreaislam/domain/channels/district_selection_channel.dart';
import 'package:koreaislam/domain/channels/gender_selection_channel.dart';
import 'package:koreaislam/domain/channels/language_selection_channel.dart';
import 'package:koreaislam/domain/channels/login_event_channel.dart';
import 'package:koreaislam/domain/channels/logout_event_channel.dart';
import 'package:koreaislam/domain/channels/region_selection_channel.dart';

extension GetItModuleChannel on GetIt {
  Future<void> channelModule() async {
    registerLazySingleton(() => AppThemeModeChannel());

    registerLazySingleton(() => CountrySelectionChannel());

    registerLazySingleton(() => DistrictSelectionChannel());

    registerLazySingleton(() => GenderSelectionChannel());

    registerLazySingleton(() => LanguageSelectionChannel());
    registerLazySingleton(() => LoginEventChannel());
    registerLazySingleton(() => LogoutEventChannel());

    registerLazySingleton(() => RegionSelectionChannel());

    await allReady();
  }
}
