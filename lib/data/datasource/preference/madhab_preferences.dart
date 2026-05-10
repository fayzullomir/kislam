import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:koreaislam/data/datasource/preference/preferences_extensions.dart';
import 'package:koreaislam/domain/models/madhab/madhab.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists the user's selected madhab and exposes a [ValueNotifier] so
/// any widget can rebuild reactively when the picker sheet writes a new
/// value — no Cubit / DI plumbing needed at the call sites.
class MadhabPreferences {
  final SharedPreferences _preferences;

  /// Singleton notifier seeded from disk on construction; subsequent
  /// writes go through [setMadhab].
  final ValueNotifier<Madhab> notifier;

  MadhabPreferences(this._preferences)
      : notifier = ValueNotifier(
          Madhab.valueOrDefault(_preferences.getString(_keyMadhab)),
        );

  static const String _keyMadhab = 'application_madhab';

  @factoryMethod
  static Future<MadhabPreferences> create() async {
    final prefs = await SharedPreferences.getInstance();
    return MadhabPreferences(prefs);
  }

  Madhab get madhab => notifier.value;

  Future<void> setMadhab(Madhab madhab) async {
    await _preferences.setOrRemove(_keyMadhab, madhab.name);
    notifier.value = madhab;
  }

  Future<void> clear() async => await _preferences.remove(_keyMadhab);
}
