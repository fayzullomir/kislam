import 'package:koreaislam/core/gen/localization/strings.dart';

/// Localized month names for the calendar header. Kept separate from intl's
/// `DateFormat.MMMM` because the app does not initialize per-locale intl
/// date symbols, so month names come from the localization JSON instead.
class MonthlyPrayerTimesLocalization {
  MonthlyPrayerTimesLocalization._();

  static String monthName(int month) {
    switch (month) {
      case 1:
        return Strings.monthJanuary;
      case 2:
        return Strings.monthFebruary;
      case 3:
        return Strings.monthMarch;
      case 4:
        return Strings.monthApril;
      case 5:
        return Strings.monthMay;
      case 6:
        return Strings.monthJune;
      case 7:
        return Strings.monthJuly;
      case 8:
        return Strings.monthAugust;
      case 9:
        return Strings.monthSeptember;
      case 10:
        return Strings.monthOctober;
      case 11:
        return Strings.monthNovember;
      default:
        return Strings.monthDecember;
    }
  }

  /// Short weekday label for [weekday] (1 = Monday … 7 = Sunday).
  static String weekdayShort(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return Strings.weekdayShortMon;
      case DateTime.tuesday:
        return Strings.weekdayShortTue;
      case DateTime.wednesday:
        return Strings.weekdayShortWed;
      case DateTime.thursday:
        return Strings.weekdayShortThu;
      case DateTime.friday:
        return Strings.weekdayShortFri;
      case DateTime.saturday:
        return Strings.weekdayShortSat;
      default:
        return Strings.weekdayShortSun;
    }
  }
}
