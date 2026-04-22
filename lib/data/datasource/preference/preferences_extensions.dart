import 'package:rx_shared_preferences/rx_shared_preferences.dart';

extension SharedPreferencesExts on SharedPreferences {
  Future<void> setOrRemove(String key, dynamic value) async {
    if (value == null) {
      await remove(key);
    } else if (value is int) {
      await setInt(key, value);
    } else if (value is double) {
      await setDouble(key, value);
    } else if (value is String) {
      await setString(key, value);
    } else if (value is bool) {
      await setBool(key, value);
    } else if (value is List<String>) {
      await setStringList(key, value);
    } else {
      throw ArgumentError("Unsupported value type on set SharedPreferences");
    }
  }
}

extension RxSharedPreferencesExts on RxSharedPreferences {
  Future<void> setOrRemove(String key, dynamic value) async {
    if (value == null) {
      await remove(key);
    } else if (value is int) {
      await setInt(key, value);
    } else if (value is double) {
      await setDouble(key, value);
    } else if (value is String) {
      if (value.isEmpty) {
        await remove(key);
      } else {
        await setString(key, value);
      }
    } else if (value is bool) {
      await setBool(key, value);
    } else if (value is List<String>) {
      await setStringList(key, value);
    } else {
      throw ArgumentError("Unsupported value type: ${value.runtimeType}");
    }
  }

  int getIntOrDefault(String key, [int defaultValue = -1]) {
    return getInt(key) as int? ?? defaultValue;
  }

  /// Get string with default value
  String getStringOrDefault(String key, [String defaultValue = ""]) {
    return getString(key) as String? ?? defaultValue;
  }
}
