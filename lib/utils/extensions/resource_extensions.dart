import 'dart:ui';

import 'package:koreaislam/core/gen/assets/assets.gen.dart';
import 'package:koreaislam/core/gen/localization/strings.dart';
import 'package:koreaislam/domain/models/article/agency_article_status.dart';
import 'package:koreaislam/domain/models/calculation_method/calculation_method.dart';
import 'package:koreaislam/domain/models/gender/gender.dart';
import 'package:koreaislam/domain/models/language/language.dart';
import 'package:koreaislam/domain/models/madhab/madhab.dart';
import 'package:koreaislam/domain/models/prayer/prayer_name.dart';
import 'package:koreaislam/domain/models/prayer_notification/prayer_notification_lead_time.dart';
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

extension CalculationMethodResourceExtension on CalculationMethod {
  String get localizedName {
    switch (this) {
      case CalculationMethod.muslimWorldLeague:
        return Strings.calculationMethodMuslimWorldLeague;
      case CalculationMethod.egyptian:
        return Strings.calculationMethodEgyptian;
      case CalculationMethod.karachi:
        return Strings.calculationMethodKarachi;
      case CalculationMethod.ummAlQura:
        return Strings.calculationMethodUmmAlQura;
      case CalculationMethod.dubai:
        return Strings.calculationMethodDubai;
      case CalculationMethod.qatar:
        return Strings.calculationMethodQatar;
      case CalculationMethod.kuwait:
        return Strings.calculationMethodKuwait;
      case CalculationMethod.moonsightingCommittee:
        return Strings.calculationMethodMoonsightingCommittee;
      case CalculationMethod.northAmerica:
        return Strings.calculationMethodNorthAmerica;
      case CalculationMethod.turkiye:
        return Strings.calculationMethodTurkiye;
      case CalculationMethod.tehran:
        return Strings.calculationMethodTehran;
      case CalculationMethod.singapore:
        return Strings.calculationMethodSingapore;
      case CalculationMethod.morocco:
        return Strings.calculationMethodMorocco;
    }
  }
}

extension PrayerNameResourceExtension on PrayerName {
  /// Localized display name — only the five obligatory prayers are
  /// rendered in UI. [PrayerName.sunrise] falls back to Fajr's label
  /// since it never reaches the home/notification surface.
  String get localizedName {
    switch (this) {
      case PrayerName.fajr:
      case PrayerName.sunrise:
        return Strings.prayerFajr;
      case PrayerName.dhuhr:
        return Strings.prayerDhuhr;
      case PrayerName.asr:
        return Strings.prayerAsr;
      case PrayerName.maghrib:
        return Strings.prayerMaghrib;
      case PrayerName.isha:
        return Strings.prayerIsha;
    }
  }
}

extension PrayerNotificationLeadTimeResourceExtension
    on PrayerNotificationLeadTime {
  String get localizedName {
    switch (this) {
      case PrayerNotificationLeadTime.instantly:
        return Strings.notificationLeadTimeInstantly;
      case PrayerNotificationLeadTime.fiveMinutesBefore:
        return Strings.notificationLeadTime5Min;
      case PrayerNotificationLeadTime.tenMinutesBefore:
        return Strings.notificationLeadTime10Min;
    }
  }
}

extension MadhabResourceExtension on Madhab {
  String get localizedName {
    switch (this) {
      case Madhab.hanafi:
        return Strings.madhabHanafi;
      case Madhab.shafii:
        return Strings.madhabShafii;
      case Madhab.maliki:
        return Strings.madhabMaliki;
      case Madhab.hanbali:
        return Strings.madhabHanbali;
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
        return Assets.images.service.serviceAirTicket;
      case ServiceType.E_SIM_CONNECT:
        return Assets.images.service.serviceEsim;
      case ServiceType.HOTEL_BOOKING:
        return Assets.images.service.serviceHotelBooking;
      case ServiceType.CURRENCY_EXCHANGE:
        return Assets.images.service.serviceCurrencyExchange;
      case ServiceType.CAR_RENTAL_TRANSPORTATION:
        return Assets.images.service.serviceCarRentalTransportation;
      case ServiceType.RESTAURANT_DISCOVERY:
        return Assets.images.service.serviceRestaurantDiscovery;
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
