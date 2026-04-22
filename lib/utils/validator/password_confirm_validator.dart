import 'package:koreaislam/core/gen/localization/strings.dart';

class PasswordConfirmValidator {
  static String? validate({
    required String? password,
    required String? confirm,
  }) {
    if (confirm == null || confirm.isEmpty) {
      return Strings.validationErrorFieldIsRequired;
    }

    if (password != confirm) {
      return Strings.validationErrorPasswordConfirm;
    }

    return null;
  }
}
