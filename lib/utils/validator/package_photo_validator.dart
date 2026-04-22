import 'package:koreaislam/core/gen/localization/strings.dart';

class PackagePhotoValidator {
  static String? validate(int? value) {
    if (value == null) {
      return Strings.validationErrorFieldIsRequired;
    }

    if (value <= 0) {
      return Strings.validationErrorPackagePhotosRequired;
    }

    return null;
  }
}
