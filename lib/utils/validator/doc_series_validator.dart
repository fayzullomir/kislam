import 'package:koreaislam/core/gen/localization/strings.dart';

class DocSeriesValidator {
  static String? validate(String? value) {
    final clearedValue = value?.trim();
    if (clearedValue == null || clearedValue.isEmpty) {
      return Strings.validationErrorFieldIsRequired;
    }

    if (!RegExp(r'^[A-Z]{2}$').hasMatch(clearedValue)) {
      return Strings.validationErrorDocSeriesNotValid;
    }

    return null;
  }
}
