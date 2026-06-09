import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:koreaislam/domain/models/article/published_article.dart';
import 'package:koreaislam/domain/models/chat/chat_user.dart';
import 'package:koreaislam/domain/models/gender/gender.dart';
import 'package:koreaislam/domain/models/media/media_file.dart';
import 'package:koreaislam/domain/models/region/country.dart';
import 'package:koreaislam/domain/models/region/district.dart';
import 'package:koreaislam/domain/models/region/region.dart';
import 'package:koreaislam/presentation/features/article/detail/article_detail_page.dart';
import 'package:koreaislam/presentation/features/article/list/published_article_list_page.dart';
import 'package:koreaislam/presentation/features/article/list/published_article_type.dart';
import 'package:koreaislam/presentation/features/auth/otp_verification/otp_verification_page.dart';
import 'package:koreaislam/presentation/features/auth/sign_in/sign_in_launch_type.dart';
import 'package:koreaislam/presentation/features/auth/sign_in/sign_in_page.dart';
import 'package:koreaislam/presentation/features/auth/sign_up/sign_up_page.dart';
import 'package:koreaislam/presentation/features/book_reader/book_reader_page.dart';
import 'package:koreaislam/presentation/features/chat/chat_page.dart';
import 'package:koreaislam/presentation/features/gender/gender_selection_page.dart';
import 'package:koreaislam/presentation/features/location/location_selection_page.dart';
import 'package:koreaislam/presentation/features/madhab/madhab_selection_page.dart';
import 'package:koreaislam/presentation/features/onboarding/onboarding_page.dart';
import 'package:koreaislam/presentation/features/language/change/change_language_page.dart';
import 'package:koreaislam/presentation/features/language/set/set_language_page.dart';
import 'package:koreaislam/presentation/features/media/photo/image_viewer_page.dart';
import 'package:koreaislam/presentation/features/media/photo/locale_image_viewer_page.dart';
import 'package:koreaislam/presentation/features/notification/notification_list_page.dart';
import 'package:koreaislam/presentation/features/permission/permissions_page.dart';
import 'package:koreaislam/presentation/features/profile/edit/profile_edit_page.dart';
import 'package:koreaislam/presentation/features/qada_tracker/qada_tracker_page.dart';
import 'package:koreaislam/presentation/features/qibla/qibla_page.dart';
import 'package:koreaislam/presentation/features/region/country/country_selection_page.dart';
import 'package:koreaislam/presentation/features/region/district/district_selection_page.dart';
import 'package:koreaislam/presentation/features/region/region/region_selection_page.dart';
import 'package:koreaislam/presentation/features/session/list/active_session_list_page.dart';
import 'package:koreaislam/presentation/features/theme_mode/change_theme_mode_page.dart';
import 'package:koreaislam/presentation/features/main/features/home/home_page.dart';
import 'package:koreaislam/presentation/features/main/features/learn/learn_page.dart';
import 'package:koreaislam/presentation/features/main/features/pray/pray_page.dart';
import 'package:koreaislam/presentation/features/main/features/profile/profile_page.dart';
import 'package:koreaislam/presentation/features/main/features/quran/quran_page.dart';
import 'package:koreaislam/presentation/features/main/main_page.dart';
import 'package:koreaislam/presentation/features/namaz_detail/namaz_detail_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        ///
        /// Common routes
        ///

        /// Language
        AutoRoute(
          page: SetLanguageRoute.page,
          path: "/set_language",
          initial: false,
        ),

        /// Sign In
        AutoRoute(
          page: SignInRoute.page,
          path: '/sign_in',
        ),

        /// Sign Up OTP Verification
        AutoRoute(
          page: OtpVerificationRoute.page,
          path: '/otp_verification',
        ),

        /// Sign Up
        AutoRoute(
          page: SignUpRoute.page,
          path: '/sign_up',
        ),

        /// Onboarding
        AutoRoute(
          page: OnboardingRoute.page,
          path: '/onboarding',
        ),

        /// Madhab selection (first-run, between onboarding and location)
        AutoRoute(
          page: MadhabSelectionRoute.page,
          path: '/madhab_selection',
        ),

        /// Location selection (first-run, before permissions)
        AutoRoute(
          page: LocationSelectionRoute.page,
          path: '/location_selection',
        ),

        /// Permissions
        AutoRoute(
          page: PermissionsRoute.page,
          path: '/permissions',
        ),

        /// image viewer
        AutoRoute(
          page: ImageViewerRoute.page,
          path: '/image_viewer',
        ),

        /// Published Article Pages

        AutoRoute(
          page: PublishedArticleListRoute.page,
          path: '/published_article_list',
        ),

        AutoRoute(
          page: ArticleDetailRoute.page,
          path: '/article_detail',
        ),

        /// Profile Pages

        AutoRoute(
          page: ProfileEditRoute.page,
          path: '/profile_edit',
        ),

        /// Active Devices
        AutoRoute(
          page: ActiveSessionListRoute.page,
          path: '/active_session_list',
        ),

        /// Notification
        AutoRoute(
          page: NotificationListRoute.page,
          path: '/notification_list',
        ),

        AutoRoute(
          page: ChatRoute.page,
          path: '/chat',
        ),

        /// Qibla compass — full-screen, opened from Home quick links.
        AutoRoute(
          page: QiblaRoute.page,
          path: '/qibla',
        ),

        /// Qazo (missed-prayer) tracker — opened from Home quick links.
        AutoRoute(
          page: QadaTrackerRoute.page,
          path: '/qada-tracker',
        ),

        /// Book reader — full-screen, opened from a Kitoblar list card.
        AutoRoute(
          page: BookReaderRoute.page,
          path: '/book_reader',
        ),

        /// Namoz step-by-step detail — opened from a variant chip on the
        /// Namoz tab. Carries `namazId` + `variantId` query params.
        AutoRoute(
          page: NamazDetailRoute.page,
          path: '/namaz_detail',
        ),

        ///
        /// User role routes
        ///

        ///user-home
        AutoRoute(
          page: MainRoute.page,
          path: '/main',
          initial: false,
          children: [
            AutoRoute(
              page: HomeRoute.page,
              path: 'home',
            ),
            AutoRoute(
              page: QuranRoute.page,
              path: 'quran',
            ),
            AutoRoute(
              page: PrayRoute.page,
              path: 'pray',
            ),
            AutoRoute(
              page: LearnRoute.page,
              path: 'learn',
            ),
            AutoRoute(
              page: ProfileRoute.page,
              path: 'profile',
            ),
          ],
        ),
      ];
}
