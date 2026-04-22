import 'package:koreaislam/core/extensions/date_extensions.dart';
import 'package:koreaislam/core/gen/localization/strings.dart';

class DateValidator {
  static String? validate(String? value, {
    DateTime? minDate,
    DateTime? maxDate,
  }) {
    if (value == null || value
        .trim()
        .isEmpty) {
      return Strings.validationErrorFieldIsRequired;
    }

    final date = DateTime.tryParse(value);
    if (date == null) {
      return Strings.validationErrorDateNotValid;
    }

    if (minDate != null && date.isBefore(minDate)) {
      return Strings.validationErrorDateTooEarly(minDate.toDateString());
    }

    if (maxDate != null && date.isAfter(maxDate)) {
      return Strings.validationErrorDateTooLate(maxDate.toDateString());
    }

    return null;
  }
}
