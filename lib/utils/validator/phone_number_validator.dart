import 'package:koreaislam/core/extensions/string_extensions.dart';
import 'package:koreaislam/core/gen/localization/strings.dart';

class PhoneNumberValidator {
  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return Strings.validationErrorFieldIsRequired;
    }

    final clearedValue = value.numericOnly;
    if (clearedValue.length != 9) {
      return Strings.validationErrorPhoneNotValid;
    }

    return null;
  }
}
