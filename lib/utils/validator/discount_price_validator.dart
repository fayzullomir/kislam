import 'package:koreaislam/core/extensions/string_extensions.dart';
import 'package:koreaislam/core/gen/localization/strings.dart';

class DiscountPriceValidator {
  static String? validate({
    required double realPrice,
    required String? discountPrice,
  }) {
    if (discountPrice == null) {
      return Strings.validationErrorPriceNotValid;
    }

    final clearedValue = int.tryParse(discountPrice.numericOnly);
    if (clearedValue == null || clearedValue == 0.0) {
      return Strings.validationErrorPriceNotValid;
    }

    if (clearedValue < 0) {
      return Strings.validationErrorPriceNotPositive;
    }

    if (clearedValue >= realPrice) {
      return Strings.validationErrorDiscountMustBeLess;
    }

    return null;
  }
}
