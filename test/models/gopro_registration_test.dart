import 'package:flutter_test/flutter_test.dart';
import 'package:heroctrl/models/gopro_registration.dart';

void main() {
  group('GoProRegistration', () {
    test('creates instance with required fields', () {
      final registration = GoProRegistration(
        ssid: 'HERO3-12345',
        bssid: 'D8:96:85:12:34:56',
        serialNumber: 'H123456789',
        cameraModel: 'HERO3+ Black Edition',
        firmwareVersion: 'HD3.11.03.00',
        macAddress: 'D8:96:85:12:34:56',
        password: 'password123',
      );

      expect(registration.ssid, equals('HERO3-12345'));
      expect(registration.bssid, equals('D8:96:85:12:34:56'));
      expect(registration.serialNumber, equals('H123456789'));
      expect(registration.cameraModel, equals('HERO3+ Black Edition'));
      expect(registration.firmwareVersion, equals('HD3.11.03.00'));
      expect(registration.macAddress, equals('D8:96:85:12:34:56'));
      expect(registration.password, equals('password123'));
    });

    test('serializes to JSON correctly', () {
      final registration = GoProRegistration(
        ssid: 'HERO3-12345',
        bssid: 'D8:96:85:12:34:56',
        serialNumber: 'H123456789',
        cameraModel: 'HERO3+ Black Edition',
        firmwareVersion: 'HD3.11.03.00',
        macAddress: 'D8:96:85:12:34:56',
        password: 'password123',
      );

      final json = registration.toJson();

      expect(json['ssid'], equals('HERO3-12345'));
      expect(json['bssid'], equals('D8:96:85:12:34:56'));
      expect(json['serial_number'], equals('H123456789'));
      expect(json['camera_model'], equals('HERO3+ Black Edition'));
      expect(json['firmware_version'], equals('HD3.11.03.00'));
      expect(json['mac_address'], equals('D8:96:85:12:34:56'));
      expect(json['password'], equals('password123'));
    });

    test('deserializes from JSON correctly', () {
      final json = {
        'ssid': 'HERO3-12345',
        'bssid': 'D8:96:85:12:34:56',
        'serial_number': 'H123456789',
        'camera_model': 'HERO3+ Black Edition',
        'firmware_version': 'HD3.11.03.00',
        'mac_address': 'D8:96:85:12:34:56',
        'password': 'password123',
      };

      final registration = GoProRegistration.fromJson(json);

      expect(registration.ssid, equals('HERO3-12345'));
      expect(registration.bssid, equals('D8:96:85:12:34:56'));
      expect(registration.serialNumber, equals('H123456789'));
      expect(registration.cameraModel, equals('HERO3+ Black Edition'));
      expect(registration.firmwareVersion, equals('HD3.11.03.00'));
      expect(registration.macAddress, equals('D8:96:85:12:34:56'));
      expect(registration.password, equals('password123'));
    });

    test('round-trip JSON serialization preserves data', () {
      final original = GoProRegistration(
        ssid: 'HERO3-TEST',
        bssid: 'D8:96:85:AA:BB:CC',
        serialNumber: 'H987654321',
        cameraModel: 'HERO3+ Silver Edition',
        firmwareVersion: 'HD3.10.00.00',
        macAddress: 'D8:96:85:AA:BB:CC',
        password: 'testpass',
      );

      final json = original.toJson();
      final restored = GoProRegistration.fromJson(json);

      expect(restored.ssid, equals(original.ssid));
      expect(restored.bssid, equals(original.bssid));
      expect(restored.serialNumber, equals(original.serialNumber));
      expect(restored.cameraModel, equals(original.cameraModel));
      expect(restored.firmwareVersion, equals(original.firmwareVersion));
      expect(restored.macAddress, equals(original.macAddress));
      expect(restored.password, equals(original.password));
    });
  });
}
