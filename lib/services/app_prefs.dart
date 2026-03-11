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

  static const String _showMediaCountKey = 'show_media_count';

  /// Get whether to show the video/photo count above the mode selector.
  /// Default is true.
  static Future<bool> getShowMediaCount() async {
    final value = await _secureStorage.read(key: _showMediaCountKey);
    if (value == null) return true;
    return value == 'true';
  }

  /// Set whether to show the video/photo count above the mode selector.
  static Future<void> setShowMediaCount(bool value) async {
    await _secureStorage.write(
      key: _showMediaCountKey,
      value: value.toString(),
    );
  }
}
