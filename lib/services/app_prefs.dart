import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppPrefs {
  static final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  static const String _switchOffCameraOnDisconnectKey =
      'switch_off_camera_on_disconnect';

  /// Get whether to switch off camera on disconnect
  /// Default is false
  static Future<bool> getSwitchOffCameraOnDisconnect() async {
    final value = await _secureStorage.read(
      key: _switchOffCameraOnDisconnectKey,
    );
    if (value == null) return false; // default to false
    return value == 'true';
  }

  /// Set whether to switch off camera on disconnect
  static Future<void> setSwitchOffCameraOnDisconnect(bool value) async {
    await _secureStorage.write(
      key: _switchOffCameraOnDisconnectKey,
      value: value.toString(),
    );
  }
}
