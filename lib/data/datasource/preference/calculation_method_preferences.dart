import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:koreaislam/data/datasource/preference/preferences_extensions.dart';
import 'package:koreaislam/domain/models/calculation_method/calculation_method.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists the user's chosen prayer-time calculation method and exposes
/// a [ValueNotifier] so the home countdown / prayer-times row rebuild as
/// soon as the picker writes a new value — same pattern as
/// [MadhabPreferences].
class CalculationMethodPreferences {
  final SharedPreferences _preferences;

  /// Singleton notifier seeded from disk on construction.
  final ValueNotifier<CalculationMethod> notifier;

  CalculationMethodPreferences(this._preferences)
      : notifier = ValueNotifier(
          CalculationMethod.valueOrDefault(
            _preferences.getString(_keyMethod),
          ),
        );

  static const String _keyMethod = 'application_calculation_method';

  @factoryMethod
  static Future<CalculationMethodPreferences> create() async {
    final prefs = await SharedPreferences.getInstance();
    return CalculationMethodPreferences(prefs);
  }

  CalculationMethod get method => notifier.value;

  Future<void> setMethod(CalculationMethod method) async {
    await _preferences.setOrRemove(_keyMethod, method.name);
    notifier.value = method;
  }

  Future<void> clear() async => await _preferences.remove(_keyMethod);
}
