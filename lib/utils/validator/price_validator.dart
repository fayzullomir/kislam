import 'package:koreaislam/core/extensions/string_extensions.dart';
import 'package:koreaislam/core/gen/localization/strings.dart';

class PriceValidator {
  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return Strings.validationErrorFieldIsRequired;
    }

    final clearedValue = int.tryParse(value.numericOnly);
    if (clearedValue == null || clearedValue == 0) {
      return Strings.validationErrorPriceNotValid;
    }

    return null;
  }
}
