import 'dart:typed_data';

class CameraVersion {
  final String firmwareVersion;
  final String cameraType;

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

  CameraVersion(Uint8List bytes)
    : firmwareVersion = _parseString(bytes[3], 4, bytes),
      cameraType = _parseString(bytes[4], 5, bytes, offset: bytes[3]);
}
