import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:heroctrl/models/camera_state.dart';
import 'package:heroctrl/models/camera_status.dart';

void main() {
  group('CameraState', () {
    test('initializes with camera status', () {
      final bytes = Uint8List(64);
      bytes[19] = 0x02; // Battery level approximation
      final status = CameraStatus(bytes);

      final state = CameraState(status);

      expect(state.status, equals(status));
      expect(state.isCameraOn, isFalse);
      expect(state.isPreviewOn, isFalse);
    });

    test('calculates battery percent from status battery level', () {
      final bytes = Uint8List(64);

      // Battery level 0 = 0%
      bytes[19] = 0x00;
      final state1 = CameraState(CameraStatus(bytes));
      expect(state1.batteryPercent, equals(0));

      // Battery level 1 = 25%
      bytes[19] = 0x01;
      final state2 = CameraState(CameraStatus(bytes));
      expect(state2.batteryPercent, equals(25));

      // Battery level 2 = 50%
      bytes[19] = 0x02;
      final state3 = CameraState(CameraStatus(bytes));
      expect(state3.batteryPercent, equals(50));

      // Battery level 3 = 75%
      bytes[19] = 0x03;
      final state4 = CameraState(CameraStatus(bytes));
      expect(state4.batteryPercent, equals(75));
    });

    test('allows updating camera on state', () {
      final bytes = Uint8List(64);
      final status = CameraStatus(bytes);
      final state = CameraState(status);

      expect(state.isCameraOn, isFalse);

      state.isCameraOn = true;
      expect(state.isCameraOn, isTrue);
    });

    test('allows updating preview on state', () {
      final bytes = Uint8List(64);
      final status = CameraStatus(bytes);
      final state = CameraState(status);

      expect(state.isPreviewOn, isFalse);

      state.isPreviewOn = true;
      expect(state.isPreviewOn, isTrue);
    });

    test('allows replacing status', () {
      final bytes1 = Uint8List(64);
      bytes1[1] = 0x00; // Video mode
      final status1 = CameraStatus(bytes1);

      final bytes2 = Uint8List(64);
      bytes2[1] = 0x01; // Photo mode
      final status2 = CameraStatus(bytes2);

      final state = CameraState(status1);
      expect(state.status, equals(status1));

      state.status = status2;
      expect(state.status, equals(status2));
    });
  });
}
