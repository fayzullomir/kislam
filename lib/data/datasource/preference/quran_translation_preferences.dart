import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:koreaislam/data/datasource/preference/preferences_extensions.dart';
import 'package:koreaislam/domain/models/quran/quran_translation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists the user's chosen Quran translation and exposes a
/// [ValueNotifier] so any widget can rebuild reactively when the picker
/// sheet writes a new value — same pattern as [MadhabPreferences].
class QuranTranslationPreferences {
  final SharedPreferences _preferences;

  /// Singleton notifier seeded from disk on construction.
  final ValueNotifier<QuranTranslation> notifier;

  QuranTranslationPreferences(this._preferences)
      : notifier = ValueNotifier(
          QuranTranslation.valueOrDefault(
            _preferences.getString(_keyTranslation),
          ),
        );

  static const String _keyTranslation = 'application_quran_translation';

  @factoryMethod
  static Future<QuranTranslationPreferences> create() async {
    final prefs = await SharedPreferences.getInstance();
    return QuranTranslationPreferences(prefs);
  }

  QuranTranslation get translation => notifier.value;

  Future<void> setTranslation(QuranTranslation translation) async {
    await _preferences.setOrRemove(_keyTranslation, translation.name);
    notifier.value = translation;
  }

  Future<void> clear() async => await _preferences.remove(_keyTranslation);
}
