extension StringPhoneNumberExtensions on String {
  static const String _uzbekistanCode = '998';
  static const int _localPhoneLength = 9;
  static const String _ltrMark = '\u200E';
  static final RegExp _nonDigitPattern = RegExp(r'[^\d]');

  /// Removes all non-digit characters from phone string
  /// Example: "+998 90 123-45-67" -> "998901234567"
  String get digitsOnly {
    return replaceAll(_nonDigitPattern, '');
  }

  /// Clears phone and adds country code if missing
  /// Example: "901234567" -> "998901234567"
  String get normalized {
    final cleaned = digitsOnly;
    if (cleaned.length == _localPhoneLength) {
      return '$_uzbekistanCode$cleaned';
    }
    return cleaned;
  }

  /// Returns phone without country code
  /// Example: "998901234567" -> "901234567"
  String get withoutCountryCode {
    final cleaned = digitsOnly;
    if (cleaned.length > _localPhoneLength &&
        cleaned.startsWith(_uzbekistanCode)) {
      return cleaned.substring(_uzbekistanCode.length);
    }
    return cleaned;
  }

  /// Formats phone number for display
  /// Example: "998901234567" -> "+998 90 123 45 67"
  String get formatted {
    final phone = normalized;
    if (phone.length < 12) return this;

    return '$_ltrMark+${phone.substring(0, 3)} '
        '${phone.substring(3, 5)} '
        '${phone.substring(5, 8)} '
        '${phone.substring(8, 10)} '
        '${phone.substring(10)}';
  }

  /// Validates if string is a valid Uzbekistan phone number
  bool get isValidUzbekPhone {
    final phone = digitsOnly;
    return phone.length == 12 && phone.startsWith(_uzbekistanCode);
  }
}