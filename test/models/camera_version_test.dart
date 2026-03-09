import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:heroctrl/models/camera_version.dart';

void main() {
  group('CameraVersion', () {
    test('parses firmware version with correct length', () {
      final bytes = Uint8List(64);

      // Byte 3 contains the length of firmware version string
      bytes[3] = 12; // "HD3.11.03.00" is 12 characters

      // Starting at byte 4, set firmware version
      final firmwareChars = 'HD3.11.03.00'.codeUnits;
      for (int i = 0; i < firmwareChars.length; i++) {
        bytes[4 + i] = firmwareChars[i];
      }

      // Set camera type length and value
      bytes[4 + bytes[3]] = 5; // "HERO3" is 5 characters
      final cameraChars = 'HERO3'.codeUnits;
      for (int i = 0; i < cameraChars.length; i++) {
        bytes[5 + bytes[3] + i] = cameraChars[i];
      }

      final version = CameraVersion(bytes);

      expect(version.firmwareVersion, equals('HD3.11.03.00'));
    });

    test('parses camera type with correct length', () {
      final bytes = Uint8List(64);

      // Set firmware version (length in byte 3)
      bytes[3] = 10;
      final firmwareChars = 'FW_1.0.0.0'.codeUnits;
      for (int i = 0; i < firmwareChars.length; i++) {
        bytes[4 + i] = firmwareChars[i];
      }

      // Set camera type
      bytes[4 + bytes[3]] = 11; // "HERO3+Black" is 11 characters
      final cameraChars = 'HERO3+Black'.codeUnits;
      for (int i = 0; i < cameraChars.length; i++) {
        bytes[5 + bytes[3] + i] = cameraChars[i];
      }

      final version = CameraVersion(bytes);

      expect(version.cameraType, equals('HERO3+Black'));
    });

    test('handles typical HERO3+ firmware version', () {
      final bytes = Uint8List(64);

      bytes[3] = 12;
      final firmwareChars = 'HD3.11.03.00'.codeUnits;
      for (int i = 0; i < firmwareChars.length; i++) {
        bytes[4 + i] = firmwareChars[i];
      }

      bytes[4 + 12] = 18; // "HERO3+ Black Edition"
      final cameraChars = 'HERO3+BlackEdition'.codeUnits;
      for (int i = 0; i < cameraChars.length && i < 18; i++) {
        bytes[5 + 12 + i] = cameraChars[i];
      }

      final version = CameraVersion(bytes);

      expect(version.firmwareVersion, equals('HD3.11.03.00'));
      expect(version.cameraType, equals('HERO3+BlackEdition'));
    });

    test('handles short firmware version', () {
      final bytes = Uint8List(64);

      bytes[3] = 5;
      final firmwareChars = 'v1.00'.codeUnits;
      for (int i = 0; i < firmwareChars.length; i++) {
        bytes[4 + i] = firmwareChars[i];
      }

      bytes[4 + 5] = 5;
      final cameraChars = 'HERO2'.codeUnits;
      for (int i = 0; i < cameraChars.length; i++) {
        bytes[5 + 5 + i] = cameraChars[i];
      }

      final version = CameraVersion(bytes);

      expect(version.firmwareVersion, equals('v1.00'));
      expect(version.cameraType, equals('HERO2'));
    });

    test('handles long firmware version string', () {
      final bytes = Uint8List(64);

      bytes[3] = 20;
      final firmwareChars = 'HD3.11.03.00-BETA123'.codeUnits;
      for (int i = 0; i < firmwareChars.length; i++) {
        bytes[4 + i] = firmwareChars[i];
      }

      bytes[4 + 20] = 10;
      final cameraChars = 'HERO3+Test'.codeUnits;
      for (int i = 0; i < cameraChars.length; i++) {
        bytes[5 + 20 + i] = cameraChars[i];
      }

      final version = CameraVersion(bytes);

      expect(version.firmwareVersion, equals('HD3.11.03.00-BETA123'));
      expect(version.cameraType, equals('HERO3+Test'));
    });

    test('handles empty or zero-length strings', () {
      final bytes = Uint8List(64);

      bytes[3] = 0; // Zero length firmware
      bytes[4] = 0; // Zero length camera type

      final version = CameraVersion(bytes);

      expect(version.firmwareVersion, equals(''));
      expect(version.cameraType, equals(''));
    });

    test('correctly calculates offsets for camera type', () {
      final bytes = Uint8List(64);

      // Variable firmware length
      bytes[3] = 8;
      final firmwareChars = 'FW_2.0.0'.codeUnits;
      for (int i = 0; i < firmwareChars.length; i++) {
        bytes[4 + i] = firmwareChars[i];
      }

      // Camera type starts at 4 + firmware_length
      // Length is at bytes[4 + bytes[3]]
      bytes[4 + 8] = 6;
      final cameraChars = 'HERO11'.codeUnits;
      for (int i = 0; i < cameraChars.length; i++) {
        bytes[5 + 8 + i] = cameraChars[i];
      }

      final version = CameraVersion(bytes);

      expect(version.firmwareVersion, equals('FW_2.0.0'));
      expect(version.cameraType, equals('HERO11'));
    });

    test('handles firmware with special characters', () {
      final bytes = Uint8List(64);

      bytes[3] = 15;
      final firmwareChars = 'HD3.11.03.00-RC'.codeUnits;
      for (int i = 0; i < firmwareChars.length; i++) {
        bytes[4 + i] = firmwareChars[i];
      }

      bytes[4 + 15] = 12;
      final cameraChars = 'HERO3+_BLACK'.codeUnits;
      for (int i = 0; i < cameraChars.length; i++) {
        bytes[5 + 15 + i] = cameraChars[i];
      }

      final version = CameraVersion(bytes);

      expect(version.firmwareVersion, equals('HD3.11.03.00-RC'));
      expect(version.cameraType, equals('HERO3+_BLACK'));
    });

    test('parses real-world HERO3+ Silver version', () {
      final bytes = Uint8List(64);

      bytes[3] = 12;
      final firmwareChars = 'HD3.10.00.00'.codeUnits;
      for (int i = 0; i < firmwareChars.length; i++) {
        bytes[4 + i] = firmwareChars[i];
      }

      bytes[4 + 12] = 21;
      final cameraChars = 'HERO3+ Silver Edition'.codeUnits;
      for (int i = 0; i < cameraChars.length; i++) {
        bytes[5 + 12 + i] = cameraChars[i];
      }

      final version = CameraVersion(bytes);

      expect(version.firmwareVersion, equals('HD3.10.00.00'));
      expect(version.cameraType, equals('HERO3+ Silver Edition'));
    });
  });
}
