import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:koreaislam/core/extensions/list_extensions.dart';
import 'package:koreaislam/core/log/logger/app_log.dart';

enum UserRole {
  user('user'),
  unknown('unknown');

  final String apiValue;

  const UserRole(this.apiValue);

  String get apiPath {
    return switch (this) {
      UserRole.user => "user",
      UserRole.unknown => "user",
    };
  }

  static UserRole valueOrDefault(String? value) {
    if (value == null || value.isEmpty) return UserRole.unknown;

    final byName = UserRole.values.firstIf((e) => e.name == value);
    if (byName != null) return byName;

    final byApiValue = UserRole.values.firstIf((e) => e.apiValue == value);
    if (byApiValue != null) return byApiValue;

    AppLog.e("UserRole.fromValue: unknown value '$value'");
    FirebaseCrashlytics.instance.recordError(UnsupportedError("UserRole.valueOrDefault: unknown UserRole value '$value'"), null);
    return UserRole.unknown;
  }
}
