import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class DevicePreferences {
  final SharedPreferences _preferences;

  DevicePreferences(this._preferences);

  static const String _keyDevicePermanentId = "string_device_permanent_id";
  static const String _keyDeviceSessionId = "string_device_session_id";

  @factoryMethod
  static Future<DevicePreferences> create() async {
    final prefs = await SharedPreferences.getInstance();
    return DevicePreferences(prefs);
  }

  String get devicePermanentId {
    String? id = _preferences.getString(_keyDevicePermanentId);
    if (id == null || id.isEmpty) {
      id = const Uuid().v4();
      _preferences.setString(_keyDevicePermanentId, id);
    }
    return id;
  }

  String get deviceSessionId {
    String? id = _preferences.getString(_keyDeviceSessionId);
    if (id == null || id.isEmpty) {
      id = const Uuid().v4();
      _preferences.setString(_keyDeviceSessionId, id);
    }
    return id;
  }

  Future<String> regenerateSessionId() async {
    final newId = const Uuid().v4();
    await _preferences.setString(_keyDeviceSessionId, newId);
    return newId;
  }

  Future<void> clear() async {
    // await _preferences.remove(_keyDeviceSessionId);
    await regenerateSessionId();
  }
}
