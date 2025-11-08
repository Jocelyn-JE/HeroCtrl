import 'dart:typed_data';

class CameraVersion {
  final String firmwareVersion;
  final String cameraType;

  static String _parseString(int length, int index, Uint8List bytes) {
    return String.fromCharCodes(
      Uint8List.sublistView(bytes, index, index + length),
    );
  }

  CameraVersion(Uint8List bytes)
    : firmwareVersion = _parseString(bytes[3], 4, bytes),
      cameraType = _parseString(bytes[4 + bytes[3]], 5 + bytes[3], bytes);
}
