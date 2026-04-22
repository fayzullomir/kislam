import 'package:flutter/material.dart';
import 'package:koreaislam/core/gen/localization/strings.dart';
import 'package:koreaislam/core/log/logger/app_log.dart';

class ProductCreationDefaultValidator {
  static GlobalKey? _firstErrorKey;

  static String? validate(String? value, GlobalKey globalKey) {
    String? errorMessage;
    if (value == null || value.trim().isEmpty) {
      errorMessage = Strings.validationErrorFieldIsRequired;

      _firstErrorKey ??= globalKey;
    }

    return errorMessage;
  }

  static void scrollToFirstError() {
    AppLog.d(_firstErrorKey.toString());
    if (_firstErrorKey != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Scrollable.ensureVisible(
          _firstErrorKey!.currentContext!,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeOut,
        );
      });
      _firstErrorKey = null;
    }
  }
}
