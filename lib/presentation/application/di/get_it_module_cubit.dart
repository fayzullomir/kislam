import 'package:get_it/get_it.dart';
import 'package:koreaislam/presentation/features/article/detail/article_detail_cubit.dart';
import 'package:koreaislam/presentation/features/article/list/published_article_list_cubit.dart';
import 'package:koreaislam/presentation/features/auth/otp_verification/otp_verification_cubit.dart';
import 'package:koreaislam/presentation/features/auth/sign_in/sign_in_cubit.dart';
import 'package:koreaislam/presentation/features/auth/sign_up/sign_up_cubit.dart';
import 'package:koreaislam/presentation/features/chat/chat_cubit.dart';
import 'package:koreaislam/presentation/features/gender/gender_selection_cubit.dart';
import 'package:koreaislam/presentation/features/intro/intro_cubit.dart';
import 'package:koreaislam/presentation/features/language/change/change_language_cubit.dart';
import 'package:koreaislam/presentation/features/language/set/set_language_cubit.dart';
import 'package:koreaislam/presentation/features/notification/notification_list_cubit.dart';
import 'package:koreaislam/presentation/features/permission/permissions_cubit.dart';
import 'package:koreaislam/presentation/features/profile/edit/profile_edit_cubit.dart';
import 'package:koreaislam/presentation/features/region/country/country_selection_cubit.dart';
import 'package:koreaislam/presentation/features/region/district/district_selection_cubit.dart';
import 'package:koreaislam/presentation/features/region/region/region_selection_cubit.dart';
import 'package:koreaislam/presentation/features/session/list/active_session_list_cubit.dart';
import 'package:koreaislam/presentation/features/theme_mode/change_theme_mode_cubit.dart';
import 'package:koreaislam/presentation/features/main/features/home/home_cubit.dart';
import 'package:koreaislam/presentation/features/main/features/knowledge/knowledge_cubit.dart';
import 'package:koreaislam/presentation/features/main/features/learn/learn_cubit.dart';
import 'package:koreaislam/presentation/features/main/features/profile/profile_cubit.dart';
import 'package:koreaislam/presentation/features/main/features/quran/quran_cubit.dart';
import 'package:koreaislam/presentation/features/main/main_cubit.dart';
import 'package:koreaislam/presentation/support/state_message/state_message_manager.dart';
import 'package:koreaislam/presentation/support/state_message/state_message_manager_impl.dart';

extension GetItModuleApp on GetIt {
  Future<void> appModule() async {
    registerSingleton<StateMessageManager>(StateMessageManagerImpl());

    // Common
    registerFactory(() => ActiveSessionListCubit(get()));
    registerFactory(() => ArticleDetailCubit(get()));

    registerFactory(() => ChangeLanguageCubit(get(), get()));
    registerFactory(() => ChangeThemeModeCubit(get(), get()));
    registerFactory(() => ChatCubit());
    registerFactory(() => CountrySelectionCubit(get(), get()));

    registerFactory(() => DistrictSelectionCubit(get(), get()));

    registerFactory(() => GenderSelectionCubit(get()));

    registerFactory(() => IntroCubit(get()));

    registerFactory(() => NotificationListCubit(get()));

    registerFactory(() => OtpVerificationCubit(get()));

    registerFactory(() => PermissionsCubit());
    registerFactory(() => PublishedArticleListCubit(get()));
    registerFactory(() => ProfileEditCubit(get(), get()));

    registerFactory(() => RegionSelectionCubit(get(), get()));

    registerFactory(() => SetLanguageCubit(get(), get()));
    registerFactory(() => SignInCubit(get(), get(), get()));
    registerFactory(() => SignUpCubit(get(), get(), get(), get(), get(), get(), get()));

    // Main
    registerFactory(() => MainCubit());
    registerFactory(() => HomeCubit(get(), get(), get()));
    registerFactory(() => QuranCubit(get()));
    registerFactory(() => LearnCubit(get()));
    registerFactory(() => KnowledgeCubit());
    registerFactory(() => ProfileCubit(get(), get(), get()));

    await allReady();
  }
}
