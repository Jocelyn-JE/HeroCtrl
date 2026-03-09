import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:heroctrl/models/camera_serial_and_mac.dart';

void main() {
  group('CameraSerialAndMac', () {
    test('parses serial number from bytes 19-32', () {
      final bytes = Uint8List(64);
      // Set serial number at bytes 19-32 (14 characters)
      final serialChars = 'H123456789ABCD'.codeUnits;
      for (int i = 0; i < serialChars.length; i++) {
        bytes[19 + i] = serialChars[i];
      }

      final camera = CameraSerialAndMac(bytes);

      expect(camera.serialNumber, equals('H123456789ABCD'));
    });

    test('parses MAC address from bytes 1-6', () {
      final bytes = Uint8List(64);
      // Set MAC address bytes (1-6)
      bytes[1] = 0xD8;
      bytes[2] = 0x96;
      bytes[3] = 0x85;
      bytes[4] = 0x12;
      bytes[5] = 0x34;

      final camera = CameraSerialAndMac(bytes);

      expect(camera.macAddress, equals('d8:96:85:12:34'));
    });

    test('formats MAC address with correct separators', () {
      final bytes = Uint8List(64);
      bytes[1] = 0xAA;
      bytes[2] = 0xBB;
      bytes[3] = 0xCC;
      bytes[4] = 0xDD;
      bytes[5] = 0xEE;

      final camera = CameraSerialAndMac(bytes);

      expect(camera.macAddress, equals('aa:bb:cc:dd:ee'));
      expect(camera.macAddress.split(':').length, equals(5));
    });

    test('pads MAC address bytes with leading zeros', () {
      final bytes = Uint8List(64);
      bytes[1] = 0x01;
      bytes[2] = 0x02;
      bytes[3] = 0x03;
      bytes[4] = 0x04;
      bytes[5] = 0x05;

      final camera = CameraSerialAndMac(bytes);

      expect(camera.macAddress, equals('01:02:03:04:05'));
    });

    test('handles typical GoPro HERO3+ serial and MAC', () {
      final bytes = Uint8List(64);

      // Set typical HERO3+ MAC address
      bytes[1] = 0xD8;
      bytes[2] = 0x96;
      bytes[3] = 0x85;
      bytes[4] = 0xAB;
      bytes[5] = 0xCD;

      // Set typical serial number
      final serialChars = 'C3131234567890'.codeUnits;
      for (int i = 0; i < serialChars.length; i++) {
        bytes[19 + i] = serialChars[i];
      }

      final camera = CameraSerialAndMac(bytes);

      expect(camera.serialNumber, equals('C3131234567890'));
      expect(camera.macAddress, equals('d8:96:85:ab:cd'));
    });

    test('handles serial number with special characters', () {
      final bytes = Uint8List(64);

      // Serial with hyphens and mixed case
      final serialChars = 'H3+-TEST123456'.codeUnits;
      for (int i = 0; i < serialChars.length; i++) {
        bytes[19 + i] = serialChars[i];
      }

      final camera = CameraSerialAndMac(bytes);

      expect(camera.serialNumber, equals('H3+-TEST123456'));
    });

    test('handles empty or zero-filled data', () {
      final bytes = Uint8List(64); // All zeros

      final camera = CameraSerialAndMac(bytes);

      expect(camera.serialNumber.length, equals(14));
      expect(camera.macAddress, equals('00:00:00:00:00'));
    });

    test('correctly extracts 14-character serial number', () {
      final bytes = Uint8List(64);

      // Fill with identifiable pattern
      final serialChars = '12345678901234'.codeUnits;
      for (int i = 0; i < serialChars.length; i++) {
        bytes[19 + i] = serialChars[i];
      }

      final camera = CameraSerialAndMac(bytes);

      expect(camera.serialNumber.length, equals(14));
      expect(camera.serialNumber, equals('12345678901234'));
    });

    test('MAC address handles max byte values', () {
      final bytes = Uint8List(64);
      bytes[1] = 0xFF;
      bytes[2] = 0xFF;
      bytes[3] = 0xFF;
      bytes[4] = 0xFF;
      bytes[5] = 0xFF;

      final camera = CameraSerialAndMac(bytes);

      expect(camera.macAddress, equals('ff:ff:ff:ff:ff'));
    });
  });
}
