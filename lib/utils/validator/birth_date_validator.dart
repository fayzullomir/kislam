import 'package:koreaislam/core/gen/localization/strings.dart';

class BirthDateValidator {
  static String? validate(String? value) {
    final clearedValue = value?.trim();
    if (clearedValue == null || clearedValue.trim().isEmpty) {
      return Strings.validationErrorFieldIsRequired;
    }

    if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(clearedValue)) {
      return Strings.validationErrorBirthDateNotValid;
    }

    final date = DateTime.tryParse(clearedValue);
    if (date == null) {
      return Strings.validationErrorBirthDateNotValid;
    }
    final minDate = DateTime(1930);
    final maxDate = DateTime.now();
    if (date.isBefore(minDate) || date.isAfter(maxDate)) {
      return Strings.validationErrorBirthDateNotValid;
    }

    return null;
  }
}
