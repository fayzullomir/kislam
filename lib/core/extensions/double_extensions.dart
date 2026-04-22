import 'package:easy_localization/easy_localization.dart';

extension DoubleExtensions on double {
  double get truncatedToOneDecimal {
    return (isNaN || isInfinite) ? 0 : (this * 10).truncateToDouble() / 10;
  }

  String get formattedNumber {
    double truncated = (this * 10).truncateToDouble() / 10;

    if (truncated == truncated.toInt()) {
      return truncated.toInt().toString();
    } else {
      return truncated.toString();
    }
  }

  String get formattedWithSpace {
    try {
      // Определяем количество десятичных знаков
      int decimalPlaces = (this % 1 == 0) ? 0 : 2;

      final formatter = NumberFormat.currency(
        locale: 'uz_UZ',
        decimalDigits: decimalPlaces,
        symbol: '',
        customPattern: decimalPlaces == 0 ? '#,##0' : '#,##0.00',
      );

      return formatter.format(this).trim();
    } catch (_) {
      // Fallback форматирование
      if (this % 1 == 0) {
        // Если число целое, показываем без десятичных знаков
        return toInt().toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]} '
        ).trim();
      } else {
        // Если есть дробная часть, показываем с 2 знаками
        return toStringAsFixed(2).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]} '
        ).trim();
      }
    }
  }

  // Дополнительный метод для форматирования с принудительными десятичными знаками
  String formatWithSpaceFixed({int decimalPlaces = 2}) {
    try {
      final formatter = NumberFormat.currency(
        locale: 'uz_UZ',
        decimalDigits: decimalPlaces,
        symbol: '',
        customPattern: decimalPlaces == 0 ? '#,##0' : '#,##0.${'0' * decimalPlaces}',
      );

      return formatter.format(this).trim();
    } catch (_) {
      return toStringAsFixed(decimalPlaces).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]} '
      ).trim();
    }
  }

  // Метод для форматирования суммы с валютой
  String formatCurrency({String currency = 'so\'m'}) {
    return '$formattedWithSpace $currency';
  }

  // Метод для форматирования миллионов
  String formatMillions({String suffix = 'mln'}) {
    if (this >= 1000000) {
      double millions = this / 1000000;
      return '${millions.formattedWithSpace} $suffix';
    }
    return formattedWithSpace;
  }
}
