import 'package:koreaislam/core/gen/localization/strings.dart';

class PasswordValidator {
  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return Strings.validationErrorFieldIsRequired;
    }

    // Length check
    if (value.length < 6) {
      return Strings.validationErrorPasswordMinLength;
    }

    // Uppercase letter check
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return Strings.validationErrorPasswordUppercase;
    }

    // Lowercase letter check
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return Strings.validationErrorPasswordLowercase;
    }

    // Digit check
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return Strings.validationErrorPasswordDigit;
    }

    return null;
  }
}
