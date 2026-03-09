import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:heroctrl/constants/gopro_action_enums.dart';
import 'package:heroctrl/constants/gopro_protune_enums.dart';
import 'package:heroctrl/constants/gopro_recording_enums.dart';
import 'package:heroctrl/constants/gopro_system_enums.dart';
import 'package:heroctrl/models/camera_status.dart';

void main() {
  group('CameraStatus', () {
    test('parses valid status bytes correctly', () {
      // Create a sample 64-byte status array (minimum required)
      final bytes = Uint8List(64);

      // Set specific values we want to test
      bytes[1] = 0x00; // Camera mode: video
      bytes[3] = 0x00; // Default mode: video
      bytes[4] = 0x00; // Spot meter: off
      bytes[5] = 0x00; // Timelapse interval
      bytes[6] = 0x00; // Auto power off: never
      bytes[7] = 0x00; // FOV: wide
      bytes[8] = 0x08; // Photo resolution
      bytes[13] = 0x00; // Recording progress high byte
      bytes[14] = 0x00; // Recording progress low byte
      bytes[16] = 0x02; // Volume: 100%
      bytes[17] = 0x02; // LEDs: 4 LEDs
      bytes[18] = 0x00; // Video standard bits (NTSC)
      bytes[19] = 0x02; // Battery level (approximation)
      bytes[29] = 0x00; // Shutter status: off
      bytes[50] = 0x03; // Video resolution: 1080p
      bytes[51] = 0x07; // FPS: 60fps
      bytes[52] = 0x04; // Sharpness and ISO bits
      bytes[53] = 0x00; // Exposure compensation

      final status = CameraStatus(bytes);

      expect(status.cameraMode, equals(CameraMode.videoMode));
      expect(status.defaultCameraMode, equals(DefaultCameraMode.videoMode));
      expect(status.volume, equals(Volume.percent100));
      expect(status.ledsStatus, equals(LED.fourLeds));
      expect(status.videoStandard, equals(VideoStandard.ntsc));
      expect(status.shutterStatus, isFalse);
      expect(status.videoResolution, equals(VideoResolution.res1080p));
      expect(status.fps, equals(FPS.fps60));
    });

    test('parses video standard from bit field correctly', () {
      final bytes = Uint8List(64);

      // Test NTSC (bit 5 = 0)
      bytes[18] = 0x00;
      final statusNtsc = CameraStatus(bytes);
      expect(statusNtsc.videoStandard, equals(VideoStandard.ntsc));

      // Test PAL (bit 5 = 1)
      bytes[18] = 0x20;
      final statusPal = CameraStatus(bytes);
      expect(statusPal.videoStandard, equals(VideoStandard.pal));
    });

    test('parses orientation from bit field correctly', () {
      final bytes = Uint8List(64);

      // Test upright (bit 6 = 0)
      bytes[18] = 0x00;
      final statusUp = CameraStatus(bytes);
      expect(statusUp.orientation, equals(Orientation.up));

      // Test upside down (bit 6 = 1)
      bytes[18] = 0x04;
      final statusDown = CameraStatus(bytes);
      expect(statusDown.orientation, equals(Orientation.down));
    });

    test('parses locate status from bit field correctly', () {
      final bytes = Uint8List(64);

      // Test locate off (bit 7 = 0)
      bytes[18] = 0x00;
      final statusOff = CameraStatus(bytes);
      expect(statusOff.locateStatus, equals(Locate.off));

      // Test locate on (bit 7 = 1)
      bytes[18] = 0x40;
      final statusOn = CameraStatus(bytes);
      expect(statusOn.locateStatus, equals(Locate.on));
    });

    test('parses multi-byte integers correctly', () {
      final bytes = Uint8List(64);

      // Test recording progress (bytes 13-14)
      bytes[13] = 0x01; // High byte
      bytes[14] = 0x2C; // Low byte (1*256 + 44 = 300 seconds)
      final status = CameraStatus(bytes);
      expect(status.recordingProgress, equals(300));

      // Test photos remaining (bytes 21-22)
      bytes[21] = 0x00;
      bytes[22] = 0x64; // 100 photos
      final status2 = CameraStatus(bytes);
      expect(status2.photosRemaining, equals(100));
    });

    test('handles shutter status correctly', () {
      final bytes = Uint8List(64);

      bytes[29] = 0x00;
      final statusOff = CameraStatus(bytes);
      expect(statusOff.shutterStatus, isFalse);

      bytes[29] = 0x01;
      final statusOn = CameraStatus(bytes);
      expect(statusOn.shutterStatus, isTrue);
    });

    test('parses ProTune settings from bit field correctly', () {
      final bytes = Uint8List(64);

      // Test ProTune off, GoPro color, no low light
      bytes[30] = 0x00;
      final status1 = CameraStatus(bytes);
      expect(status1.protuneStatus, equals(ProTune.off));
      expect(status1.colorProfile, equals(ColorProfile.goPro));
      expect(status1.lowLightMode, equals(LowLight.off));

      // Test ProTune on (bit 2 = 1), Flat color (bit 8 = 1), Low light on (bit 7 = 1)
      bytes[30] = 0xC2; // 11000010
      final status2 = CameraStatus(bytes);
      expect(status2.protuneStatus, equals(ProTune.on));
      expect(status2.colorProfile, equals(ColorProfile.flat));
      expect(status2.lowLightMode, equals(LowLight.on));
    });

    test('parses sharpness and ISO from shared byte correctly', () {
      final bytes = Uint8List(64);

      // Sharpness is bits 3-4, ISO is bits 1-2
      // Low sharpness (00), ISO 6400 (00)
      bytes[52] = 0x00;
      final status1 = CameraStatus(bytes);
      expect(status1.sharpness, equals(Sharpness.low));
      expect(status1.iso, equals(ISOLimit.iso6400));

      // Medium sharpness (01), ISO 1600 (01)
      bytes[52] = 0x05; // 00000101
      final status2 = CameraStatus(bytes);
      expect(status2.sharpness, equals(Sharpness.medium));
      expect(status2.iso, equals(ISOLimit.iso1600));

      // High sharpness (10), ISO 400 (10)
      bytes[52] = 0x0A; // 00001010
      final status3 = CameraStatus(bytes);
      expect(status3.sharpness, equals(Sharpness.high));
      expect(status3.iso, equals(ISOLimit.iso400));
    });
  });
}
