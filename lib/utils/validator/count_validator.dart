import 'package:koreaislam/core/gen/localization/strings.dart';

class CountValidator {
  static String? validate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return Strings.validationErrorFieldIsRequired;
    }

    final count = int.tryParse(value);
    if (count == null || count <= 0) {
      return Strings.validationErrorCountNotValid;
    }

    return null;
  }
}
