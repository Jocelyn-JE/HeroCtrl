import 'package:flutter_test/flutter_test.dart';
import 'package:heroctrl/models/gopro_registration.dart';
import 'package:heroctrl/services/gopro_registry.dart';
import 'package:heroctrl/utils/gopro_validator.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  group('GoProValidator', () {
    group('isGoPro', () {
      test('returns true for valid HERO3/HERO3+ BSSID prefix', () {
        expect(GoProValidator.isGoPro('D8:96:85:12:34:56'), isTrue);
        expect(GoProValidator.isGoPro('d8:96:85:12:34:56'), isTrue);
        expect(GoProValidator.isGoPro('D8:96:85:AA:BB:CC'), isTrue);
      });

      test('returns false for non-GoPro BSSID', () {
        expect(GoProValidator.isGoPro('00:11:22:33:44:55'), isFalse);
        expect(GoProValidator.isGoPro('AA:BB:CC:DD:EE:FF'), isFalse);
        expect(
          GoProValidator.isGoPro('D4:D9:19:12:34:56'),
          isFalse,
        ); // HERO4 (not supported)
      });

      test('returns false for invalid BSSID format', () {
        expect(GoProValidator.isGoPro(''), isFalse);
        expect(GoProValidator.isGoPro('invalid'), isFalse);
        expect(GoProValidator.isGoPro('D8:96'), isFalse);
      });

      test('handles case insensitivity', () {
        expect(GoProValidator.isGoPro('d8:96:85:12:34:56'), isTrue);
        expect(GoProValidator.isGoPro('D8:96:85:12:34:56'), isTrue);
        expect(GoProValidator.isGoPro('D8:96:85:aa:bb:cc'), isTrue);
      });
    });

    group('allKnownPrefixes', () {
      test('returns list of all known GoPro OUI prefixes', () {
        final prefixes = GoProValidator.allKnownPrefixes;

        expect(prefixes, isNotEmpty);
        expect(prefixes, contains('D8:96:85')); // HERO3+
        expect(prefixes, contains('D4:D9:19')); // HERO4
        expect(prefixes, contains('F4:DD:9E')); // HERO5
        expect(prefixes.length, greaterThanOrEqualTo(8));
      });

      test('all prefixes are properly formatted', () {
        final prefixes = GoProValidator.allKnownPrefixes;
        final prefixPattern = RegExp(r'^[0-9A-F]{2}:[0-9A-F]{2}:[0-9A-F]{2}$');

        for (final prefix in prefixes) {
          expect(
            prefixPattern.hasMatch(prefix),
            isTrue,
            reason: 'Prefix $prefix should match XX:XX:XX format',
          );
        }
      });
    });

    group('isRegistered', () {
      setUp(() async {
        // Mock secure storage for testing
        FlutterSecureStorage.setMockInitialValues({});
        // Clear any existing registrations
        await GoProPrefs.clearAll();
      });

      tearDown(() async {
        // Clean up after tests
        await GoProPrefs.clearAll();
      });

      test('returns false for unregistered camera', () async {
        final result = await GoProValidator.isRegistered('D8:96:85:11:22:33');
        expect(result, isFalse);
      });

      test('returns true for registered camera', () async {
        // Register a test camera
        final registration = GoProRegistration(
          bssid: 'D8:96:85:11:22:33',
          password: 'test123',
          ssid: 'TestGoPro',
          serialNumber: '12345678',
          cameraModel: 'HERO3+',
          firmwareVersion: '1.0',
          macAddress: 'D8:96:85:11:22:33',
        );
        await GoProPrefs.add(registration);

        final result = await GoProValidator.isRegistered('D8:96:85:11:22:33');
        expect(result, isTrue);
      });

      test('returns false after camera is removed', () async {
        // Register and then remove a test camera
        final registration = GoProRegistration(
          bssid: 'D8:96:85:44:55:66',
          password: 'test456',
          ssid: 'TestGoPro2',
          serialNumber: '87654321',
          cameraModel: 'HERO3+',
          firmwareVersion: '1.0',
          macAddress: 'D8:96:85:44:55:66',
        );
        await GoProPrefs.add(registration);
        await GoProPrefs.removeByBssid('D8:96:85:44:55:66');

        final result = await GoProValidator.isRegistered('D8:96:85:44:55:66');
        expect(result, isFalse);
      });
    });
  });
}
