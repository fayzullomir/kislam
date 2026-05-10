import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:koreaislam/data/repositories/article/article_repository.dart';
import 'package:koreaislam/data/repositories/auth/session_repository.dart';
import 'package:koreaislam/data/repositories/auth/sign_in_repository.dart';
import 'package:koreaislam/data/repositories/auth/sign_up_repository.dart';
import 'package:koreaislam/data/repositories/banner/banner_repository.dart';
import 'package:koreaislam/data/repositories/chat/chat_repository.dart';
import 'package:koreaislam/data/repositories/config/config_repository.dart';
import 'package:koreaislam/data/repositories/notification/notification_repository.dart';
import 'package:koreaislam/data/repositories/file/file_upload_repository.dart';
import 'package:koreaislam/data/repositories/language/language_repository.dart';
import 'package:koreaislam/data/repositories/prayer_times/prayer_times_repository.dart';
import 'package:koreaislam/data/repositories/profile/profile_repository.dart';
import 'package:koreaislam/data/repositories/region/region_repository.dart';
import 'package:koreaislam/data/repositories/service/service_repository.dart';
import 'package:koreaislam/data/repositories/theme_mode/theme_mode_repository.dart';
import 'package:koreaislam/presentation/application/services/prayer/prayer_notification_scheduler.dart';

extension GetItModuleExtension on GetIt {
  Future<void> repositoryModule() async {
    registerLazySingleton(() => LanguageRepository(get(), get()));

    registerLazySingleton(() => ArticleRepository(get(), get()));

    registerLazySingleton(() => BannerRepository());

    registerLazySingleton(() => ChatRepository());
    registerLazySingleton(() => ConfigRepository(get()));

    registerLazySingleton(() => FileUploadRepository(get()));

    registerLazySingleton(() => NotificationRepository(get(), get(), get()));

    registerLazySingleton(() => PrayerTimesRepository(get(), get(), get()));

    registerLazySingleton(() => ProfileRepository(get(), get()));

    registerLazySingleton(() => RegionRepository(get()));

    registerLazySingleton(() => ServiceRepository());
    registerLazySingleton(() => SessionRepository(get(), get(), get(), get(), get(), get()));
    registerLazySingleton(() => SignInRepository(get(), get(), get(), get()));
    registerLazySingleton(() => SignUpRepository(get(), get(), get(), get()));

    registerLazySingleton(() => ThemeModeRepository(get()));

    // Notification scheduling — shares the FlutterLocalNotificationsPlugin
    // singleton with FirebaseNotificationService (the plugin itself is a
    // process-wide singleton internally).
    registerLazySingleton(() => FlutterLocalNotificationsPlugin());
    registerLazySingleton(
      () => PrayerNotificationScheduler(
        plugin: get(),
        prayerTimesRepository: get(),
        prayerNotificationPreferences: get(),
        locationPreferences: get(),
        madhabPreferences: get(),
        calculationMethodPreferences: get(),
      ),
    );

    await allReady();
  }
}
