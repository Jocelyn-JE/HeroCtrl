import 'dart:typed_data';

class CameraWifiInfo {
  final String password;
  final String ssid;

  static String _parseString(
    int length,
    int index,
    Uint8List bytes, {
    int offset = 0,
  }) {
    return String.fromCharCodes(
      Uint8List.sublistView(bytes, index + offset, index + length + offset),
    );
  }

  CameraWifiInfo(Uint8List bytes)
    : password = _parseString(bytes[1], 2, bytes),
      ssid = _parseString(bytes[2 + bytes[1]], 3 + bytes[1], bytes);
}
