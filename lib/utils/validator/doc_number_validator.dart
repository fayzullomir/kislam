import 'package:koreaislam/core/extensions/string_extensions.dart';
import 'package:koreaislam/core/gen/localization/strings.dart';

class DocNumberValidator {
  static String? validate(String? value) {
    final clearedValue = value?.trim().withoutWhitespace;
    if (clearedValue == null || clearedValue.isEmpty) {
      return Strings.validationErrorFieldIsRequired;
    }

    if (!RegExp(r'^\d{7}$').hasMatch(clearedValue)) {
      return Strings.validationErrorDocNumberNotValid;
    }

    return null;
  }
}
