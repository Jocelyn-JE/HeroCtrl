import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:heroctrl/models/camera_wifi_info.dart';

void main() {
  group('CameraWifiInfo', () {
    test('parses password from bytes starting at index 2', () {
      final bytes = Uint8List(64);

      // Byte 1 contains the length of password
      bytes[1] = 8;

      // Starting at byte 2, set password
      final passwordChars = 'pass1234'.codeUnits;
      for (int i = 0; i < passwordChars.length; i++) {
        bytes[2 + i] = passwordChars[i];
      }

      // Set SSID
      bytes[2 + bytes[1]] = 10; // SSID length
      final ssidChars = 'HERO3-1234'.codeUnits;
      for (int i = 0; i < ssidChars.length; i++) {
        bytes[3 + bytes[1] + i] = ssidChars[i];
      }

      final wifiInfo = CameraWifiInfo(bytes);

      expect(wifiInfo.password, equals('pass1234'));
    });

    test('parses SSID after password', () {
      final bytes = Uint8List(64);

      // Set password
      bytes[1] = 10;
      final passwordChars = 'mypassword'.codeUnits;
      for (int i = 0; i < passwordChars.length; i++) {
        bytes[2 + i] = passwordChars[i];
      }

      // Set SSID (starts at 2 + password_length)
      bytes[2 + bytes[1]] = 12;
      final ssidChars = 'HERO3-ABC123'.codeUnits;
      for (int i = 0; i < ssidChars.length; i++) {
        bytes[3 + bytes[1] + i] = ssidChars[i];
      }

      final wifiInfo = CameraWifiInfo(bytes);

      expect(wifiInfo.ssid, equals('HERO3-ABC123'));
    });

    test('handles typical GoPro HERO3+ WiFi credentials', () {
      final bytes = Uint8List(64);

      bytes[1] = 8;
      final passwordChars = 'password'.codeUnits;
      for (int i = 0; i < passwordChars.length; i++) {
        bytes[2 + i] = passwordChars[i];
      }

      bytes[2 + 8] = 13;
      final ssidChars = 'HERO3+-123456'.codeUnits;
      for (int i = 0; i < ssidChars.length; i++) {
        bytes[3 + 8 + i] = ssidChars[i];
      }

      final wifiInfo = CameraWifiInfo(bytes);

      expect(wifiInfo.password, equals('password'));
      expect(wifiInfo.ssid, equals('HERO3+-123456'));
    });

    test('handles short password', () {
      final bytes = Uint8List(64);

      bytes[1] = 3;
      final passwordChars = 'abc'.codeUnits;
      for (int i = 0; i < passwordChars.length; i++) {
        bytes[2 + i] = passwordChars[i];
      }

      bytes[2 + 3] = 5;
      final ssidChars = 'HERO1'.codeUnits;
      for (int i = 0; i < ssidChars.length; i++) {
        bytes[3 + 3 + i] = ssidChars[i];
      }

      final wifiInfo = CameraWifiInfo(bytes);

      expect(wifiInfo.password, equals('abc'));
      expect(wifiInfo.ssid, equals('HERO1'));
    });

    test('handles long password', () {
      final bytes = Uint8List(64);

      bytes[1] = 20;
      final passwordChars = 'verylongpassword1234'.codeUnits;
      for (int i = 0; i < passwordChars.length; i++) {
        bytes[2 + i] = passwordChars[i];
      }

      bytes[2 + 20] = 15;
      final ssidChars = 'HERO3+LongSSID1'.codeUnits;
      for (int i = 0; i < ssidChars.length; i++) {
        bytes[3 + 20 + i] = ssidChars[i];
      }

      final wifiInfo = CameraWifiInfo(bytes);

      expect(wifiInfo.password, equals('verylongpassword1234'));
      expect(wifiInfo.ssid, equals('HERO3+LongSSID1'));
    });

    test('handles password with special characters', () {
      final bytes = Uint8List(64);

      bytes[1] = 12;
      final passwordChars = 'Pass@123!#\$*'.codeUnits;
      for (int i = 0; i < passwordChars.length; i++) {
        bytes[2 + i] = passwordChars[i];
      }

      bytes[2 + 12] = 10;
      final ssidChars = 'GoPro-Test'.codeUnits;
      for (int i = 0; i < ssidChars.length; i++) {
        bytes[3 + 12 + i] = ssidChars[i];
      }

      final wifiInfo = CameraWifiInfo(bytes);

      expect(wifiInfo.password, equals('Pass@123!#\$*'));
      expect(wifiInfo.ssid, equals('GoPro-Test'));
    });

    test('handles SSID with special characters', () {
      final bytes = Uint8List(64);

      bytes[1] = 8;
      final passwordChars = 'test1234'.codeUnits;
      for (int i = 0; i < passwordChars.length; i++) {
        bytes[2 + i] = passwordChars[i];
      }

      bytes[2 + 8] = 15;
      final ssidChars = 'HERO-3+_BLACK-2'.codeUnits;
      for (int i = 0; i < ssidChars.length; i++) {
        bytes[3 + 8 + i] = ssidChars[i];
      }

      final wifiInfo = CameraWifiInfo(bytes);

      expect(wifiInfo.password, equals('test1234'));
      expect(wifiInfo.ssid, equals('HERO-3+_BLACK-2'));
    });

    test('handles empty or zero-length password', () {
      final bytes = Uint8List(64);

      bytes[1] = 0; // Zero length password

      bytes[2] = 10;
      final ssidChars = 'HERO3-Open'.codeUnits;
      for (int i = 0; i < ssidChars.length; i++) {
        bytes[3 + i] = ssidChars[i];
      }

      final wifiInfo = CameraWifiInfo(bytes);

      expect(wifiInfo.password, equals(''));
      expect(wifiInfo.ssid, equals('HERO3-Open'));
    });

    test('handles empty or zero-length SSID', () {
      final bytes = Uint8List(64);

      bytes[1] = 8;
      final passwordChars = 'password'.codeUnits;
      for (int i = 0; i < passwordChars.length; i++) {
        bytes[2 + i] = passwordChars[i];
      }

      bytes[2 + 8] = 0; // Zero length SSID

      final wifiInfo = CameraWifiInfo(bytes);

      expect(wifiInfo.password, equals('password'));
      expect(wifiInfo.ssid, equals(''));
    });

    test('correctly calculates SSID offset based on password length', () {
      final bytes = Uint8List(64);

      // Variable password length
      bytes[1] = 15;
      final passwordChars = '123456789012345'.codeUnits;
      for (int i = 0; i < passwordChars.length; i++) {
        bytes[2 + i] = passwordChars[i];
      }

      // SSID length is at bytes[2 + password_length]
      bytes[2 + 15] = 14;
      final ssidChars = 'HERO3+12345678'.codeUnits;
      for (int i = 0; i < ssidChars.length; i++) {
        bytes[3 + 15 + i] = ssidChars[i];
      }

      final wifiInfo = CameraWifiInfo(bytes);

      expect(wifiInfo.password, equals('123456789012345'));
      expect(wifiInfo.ssid, equals('HERO3+12345678'));
    });

    test('handles numeric-only credentials', () {
      final bytes = Uint8List(64);

      bytes[1] = 8;
      final passwordChars = '12345678'.codeUnits;
      for (int i = 0; i < passwordChars.length; i++) {
        bytes[2 + i] = passwordChars[i];
      }

      bytes[2 + 8] = 10;
      final ssidChars = '1234567890'.codeUnits;
      for (int i = 0; i < ssidChars.length; i++) {
        bytes[3 + 8 + i] = ssidChars[i];
      }

      final wifiInfo = CameraWifiInfo(bytes);

      expect(wifiInfo.password, equals('12345678'));
      expect(wifiInfo.ssid, equals('1234567890'));
    });
  });
}
