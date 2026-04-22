import 'package:koreaislam/core/extensions/string_extensions.dart';
import 'package:koreaislam/core/gen/localization/strings.dart';

class PinflValidator {
  static String? validate(String? value) {
    final clearedValue = value?.trim().numericOnly;
    if (clearedValue == null || clearedValue.isEmpty) {
      return Strings.validationErrorFieldIsRequired;
    }

    if (!RegExp(r'^\d{14}$').hasMatch(clearedValue)) {
      return Strings.validationErrorPinflNotValid;
    }

    return null;
  }
}
