import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:koreaislam/data/datasource/preference/preferences_extensions.dart';
import 'package:koreaislam/domain/models/location/user_location.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists the user's selected location and exposes a [ValueNotifier]
/// so any widget can rebuild reactively when the picker writes a new
/// value — same pattern as [MadhabPreferences].
class LocationPreferences {
  final SharedPreferences _preferences;

  /// Singleton notifier seeded from disk on construction.
  final ValueNotifier<UserLocation> notifier;

  LocationPreferences(this._preferences)
      : notifier = ValueNotifier(_readFromPrefs(_preferences));

  static const String _keyLatitude = 'application_location_latitude';
  static const String _keyLongitude = 'application_location_longitude';
  static const String _keyCity = 'application_location_city';
  static const String _keyCountry = 'application_location_country';

  @factoryMethod
  static Future<LocationPreferences> create() async {
    final prefs = await SharedPreferences.getInstance();
    return LocationPreferences(prefs);
  }

  UserLocation get location => notifier.value;

  bool get isLocationSet => location.isSet;

  bool get isLocationNotSet => !isLocationSet;

  Future<void> setLocation(UserLocation location) async {
    await _preferences.setOrRemove(_keyLatitude, location.latitude);
    await _preferences.setOrRemove(_keyLongitude, location.longitude);
    await _preferences.setOrRemove(_keyCity, location.city);
    await _preferences.setOrRemove(_keyCountry, location.country);
    notifier.value = location;
  }

  Future<void> clear() async {
    await _preferences.remove(_keyLatitude);
    await _preferences.remove(_keyLongitude);
    await _preferences.remove(_keyCity);
    await _preferences.remove(_keyCountry);
    notifier.value = const UserLocation();
  }

  static UserLocation _readFromPrefs(SharedPreferences prefs) {
    return UserLocation(
      latitude: prefs.getDouble(_keyLatitude),
      longitude: prefs.getDouble(_keyLongitude),
      city: prefs.getString(_keyCity),
      country: prefs.getString(_keyCountry),
    );
  }
}
