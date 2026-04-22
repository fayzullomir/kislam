import 'package:koreaislam/core/gen/localization/strings.dart';

class OrganizationNameValidator {
  static String? validate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return Strings.validationErrorFieldIsRequired;
    }

    // Пример базовой проверки: минимум 2 символа
    if (value.trim().length < 2) {
      return Strings.validationErrorNameTooShort;
    }

    // Проверка на допустимые символы: буквы, цифры, пробелы, дефис
    final nameRegex = RegExp(r'^[a-zA-Z0-9а-яА-ЯёЁ\s\-]+$');

    if (!nameRegex.hasMatch(value.trim())) {
      return Strings.validationErrorNameNotValid;
    }

    return null;
  }
}
