import 'package:intl/intl.dart';
import 'package:koreaislam/core/log/logger/app_log.dart';

extension DateExtensions on DateTime {
  String toDateString({String outputFormat = 'yyyy-MM-dd'}) {
    return DateFormat(outputFormat, 'uz').format(this);
  }

  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool isSameDay(DateTime date) {
    return year == date.year && month == date.month && day == date.day;
  }

  DateTime get startOfDay => DateTime(year, month, day);

  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);

  DateTime get startOfPreviousDay {
    final yesterday = subtract(const Duration(days: 1));
    return DateTime(yesterday.year, yesterday.month, yesterday.day);
  }

  DateTime get endOfPreviousDay {
    final yesterday = subtract(const Duration(days: 1));
    return DateTime(
        yesterday.year, yesterday.month, yesterday.day, 23, 59, 59, 999);
  }

  DateTime get startOfNextDay {
    final tomorrow = add(const Duration(days: 1));
    return DateTime(tomorrow.year, tomorrow.month, tomorrow.day);
  }

  DateTime get endOfNextDay {
    final tomorrow = add(const Duration(days: 1));
    return DateTime(
        tomorrow.year, tomorrow.month, tomorrow.day, 23, 59, 59, 999);
  }
}

extension IntDateExtensions on int {
  String toDateString({String outputFormat = 'yyyy-MM-dd'}) {
    return DateTime.fromMillisecondsSinceEpoch(this)
        .toDateString(outputFormat: outputFormat);
  }
}

bool isValidDate({required String dateString, required String format}) {
  try {
    final dateFormat = DateFormat(format);
    dateFormat.parseStrict(dateString);
    return true;
  } catch (_) {
    return false;
  }
}

extension StringDateExtensions on String {
  DateTime get asDate {
    return DateTime.parse(this);
  }

  String toLocalDate({String outputFormat = "yyyy-MM-dd HH:mm:ss"}) {
    return DateTime.tryParse(this)
            ?.toLocal()
            .toDateString(outputFormat: outputFormat) ??
        this;
  }

  bool isValidDate({required String inputFormat}) {
    try {
      final dateFormat = DateFormat(inputFormat);
      dateFormat.parseStrict(this);
      return true;
    } catch (_) {
      return false;
    }
  }

  String convertDateFormat({required String outputFormat}) {
    try {
      final date = DateTime.tryParse(this);
      if (date == null) {
        return this;
      }
      return DateFormat(outputFormat).format(date);
    } catch (e) {
      AppLog.e("convertDateFormat error", error: e);
      return this;
    }
  }
}
