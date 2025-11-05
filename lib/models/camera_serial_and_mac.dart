import 'dart:typed_data';

class CameraSerialAndMac {
  final String serialNumber; // Bytes 19-32
  final String macAddress; // Bytes 1-6

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

  static String _parseMacAddress(Uint8List bytes) {
    return bytes
        .sublist(1, 6)
        .map((b) => b.toRadixString(16).padLeft(2, '0'))
        .join(':');
  }

  CameraSerialAndMac(Uint8List bytes)
    : serialNumber = _parseString(14, 19, bytes),
      macAddress = _parseMacAddress(bytes);
}
