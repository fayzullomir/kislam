import 'dart:ui';

import 'package:koreaislam/core/gen/assets/assets.gen.dart';
import 'package:koreaislam/core/gen/localization/strings.dart';
import 'package:koreaislam/domain/models/article/agency_article_status.dart';
import 'package:koreaislam/domain/models/gender/gender.dart';
import 'package:koreaislam/domain/models/language/language.dart';
import 'package:koreaislam/domain/models/service/service_type.dart';
import 'package:koreaislam/domain/models/theme/app_theme_mode.dart';
import 'package:koreaislam/presentation/support/colors/static_colors.dart';

extension AppThemeModeResourceExtension on AppThemeMode {
  String get localizedName {
    switch (this) {
      case AppThemeMode.lightMode:
        return Strings.themeModeLightMode;
      case AppThemeMode.darkMode:
        return Strings.themeModeDarkMode;
      case AppThemeMode.followSystem:
        return Strings.themeModeFollowSystem;
    }
  }
}

extension LanguageResourceExtension on Language {
  String get localizedName {
    switch (this) {
      case Language.uzbekLatin:
        return Strings.languageUzbekLatin;
      case Language.englishUs:
        return Strings.languageEnglishUs;
      case Language.russianRu:
        return Strings.languageRussianRu;
      case Language.koreanKr:
        return Strings.languageKoreanKr;
      case Language.arabicAr:
        return Strings.languageArabicAr;
    }
  }
}

extension GenderResourceExtension on Gender {
  String get localizedName {
    switch (this) {
      case Gender.male:
        return Strings.genderMale;
      case Gender.female:
        return Strings.genderFemale;
    }
  }
}

extension ServiceTypeResExts on ServiceType {
  String get localizedName {
    switch (this) {
      case ServiceType.AIR_TICKET:
        return Strings.serviceAirTicketTitle;
      case ServiceType.E_SIM_CONNECT:
        return Strings.serviceESimConnectTitle;
      case ServiceType.HOTEL_BOOKING:
        return Strings.serviceHotelBookingTitle;
      case ServiceType.CURRENCY_EXCHANGE:
        return Strings.serviceCurrencyExchangeTitle;
      case ServiceType.CAR_RENTAL_TRANSPORTATION:
        return Strings.serviceCarRentalTransportationTitle;
      case ServiceType.RESTAURANT_DISCOVERY:
        return Strings.serviceRestaurantDiscoveryTitle;
    }
  }

  String get localizedDesc {
    switch (this) {
      case ServiceType.AIR_TICKET:
        return Strings.serviceAirTicketDesc;
      case ServiceType.E_SIM_CONNECT:
        return Strings.serviceESimConnectDesc;
      case ServiceType.HOTEL_BOOKING:
        return Strings.serviceHotelBookingDesc;
      case ServiceType.CURRENCY_EXCHANGE:
        return Strings.serviceCurrencyExchangeDesc;
      case ServiceType.CAR_RENTAL_TRANSPORTATION:
        return Strings.serviceCarRentalTransportationDesc;
      case ServiceType.RESTAURANT_DISCOVERY:
        return Strings.serviceRestaurantDiscoveryDesc;
    }
  }

  SvgGenImage get serviceIcon {
    switch (this) {
      case ServiceType.AIR_TICKET:
        return Assets.images.service.airTicket;
      case ServiceType.E_SIM_CONNECT:
        return Assets.images.service.esim;
      case ServiceType.HOTEL_BOOKING:
        return Assets.images.service.hotelBooking;
      case ServiceType.CURRENCY_EXCHANGE:
        return Assets.images.service.currencyExchange;
      case ServiceType.CAR_RENTAL_TRANSPORTATION:
        return Assets.images.service.carRentalTransportation;
      case ServiceType.RESTAURANT_DISCOVERY:
        return Assets.images.service.restaurantDiscovery;
    }
  }
}

extension UserAdStatusResExts on AgencyArticleStatus {
  String get localizedName {
    switch (this) {
      case AgencyArticleStatus.published:
        return Strings.articleStatusActive;
      case AgencyArticleStatus.inModeration:
        return Strings.articleStatusInReview;
      case AgencyArticleStatus.unPublished:
        return Strings.articleStatusInactive;
      case AgencyArticleStatus.rejected:
        return Strings.articleStatusRejected;
    }
  }

  String get localizedDescName {
    switch (this) {
      case AgencyArticleStatus.published:
        return Strings.articleStatusActiveDesc;
      case AgencyArticleStatus.inModeration:
        return Strings.articleStatusInReviewDesc;
      case AgencyArticleStatus.unPublished:
        return Strings.articleStatusInactiveDesc;
      case AgencyArticleStatus.rejected:
        return Strings.articleStatusRejectedDesc;
    }
  }

  Color get statusColor {
    switch (this) {
      case AgencyArticleStatus.published:
        return StaticColors.statusCompleted;
      case AgencyArticleStatus.inModeration:
        return StaticColors.statusPending;
      case AgencyArticleStatus.unPublished:
        return StaticColors.statusConfirmed;
      case AgencyArticleStatus.rejected:
        return StaticColors.statusRejected;
    }
  }
}
