import 'package:koreaislam/core/gen/localization/strings.dart';

class NotEmptyValidator {
  static String? validate(String? value, {bool validateIfModifiedEmpty = true}) {
    String? errorMessage;
    if ((value == null || value.trim().isEmpty) && validateIfModifiedEmpty) {
      errorMessage = Strings.validationErrorFieldIsRequired;
    }

    return errorMessage;
  }
}
