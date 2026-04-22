extension StringFormattingExtensions on String {
  static final RegExp _whitespacePattern = RegExp(r'\s+');
  static final RegExp _nonNumericPattern = RegExp(r'[^\d.]');

  /// Removes all whitespace characters
  /// Example: "Hello   World" -> "HelloWorld"
  String get withoutWhitespace {
    return replaceAll(_whitespacePattern, '');
  }

  /// Normalizes multiple spaces to single space
  /// Example: "Hello   World" -> "Hello World"
  String get normalizedWhitespace {
    return replaceAll(_whitespacePattern, ' ').trim();
  }

  /// Extracts only numeric characters and decimal point
  /// Example: "1,234.56 USD" -> "1234.56"
  String get numericOnly {
    return replaceAll(_nonNumericPattern, '');
  }

  /// Converts string to double or returns null
  double? get asDouble {
    final numeric = numericOnly;
    return double.tryParse(numeric);
  }

  /// Converts string to int or returns null
  int? get asInt {
    final numeric = numericOnly.split('.').first;
    return int.tryParse(numeric);
  }

  /// Checks if string contains only digits
  bool get isDigitsOnly => RegExp(r'^\d+$').hasMatch(this);

  /// Checks if string is empty or contains only whitespace
  bool get isBlank => trim().isEmpty;

  /// Checks if string is not blank
  bool get isNotBlank => !isBlank;
}