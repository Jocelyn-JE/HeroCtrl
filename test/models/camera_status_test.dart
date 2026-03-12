import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:heroctrl/gopro_settings/actions.dart';
import 'package:heroctrl/gopro_settings/photo.dart';
import 'package:heroctrl/gopro_settings/protune.dart';
import 'package:heroctrl/gopro_settings/recording.dart';
import 'package:heroctrl/gopro_settings/system.dart';
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
      expect(status.ledsStatus, equals(Led.fourLeds));
      expect(status.videoStandard, equals(VideoStandard.ntsc));
      expect(status.shutterStatus, isFalse);
      expect(status.videoResolution, equals(VideoResolution.res1080p));
      expect(status.fps, equals(Fps.fps60));
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
      expect(statusUp.orientation, equals(CameraOrientation.up));

      // Test upside down (bit 6 = 1)
      bytes[18] = 0x04;
      final statusDown = CameraStatus(bytes);
      expect(statusDown.orientation, equals(CameraOrientation.down));
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
      expect(status1.iso, equals(IsoLimit.iso6400));

      // Medium sharpness (01), ISO 1600 (01)
      bytes[52] = 0x05; // 00000101
      final status2 = CameraStatus(bytes);
      expect(status2.sharpness, equals(Sharpness.medium));
      expect(status2.iso, equals(IsoLimit.iso1600));

      // High sharpness (10), ISO 400 (10)
      bytes[52] = 0x0A; // 00001010
      final status3 = CameraStatus(bytes);
      expect(status3.sharpness, equals(Sharpness.high));
      expect(status3.iso, equals(IsoLimit.iso400));

      // Test invalid/default sharpness value (11)
      bytes[52] = 0x0C; // 00001100 - bits 3-4 = 11 (invalid)
      final status4 = CameraStatus(bytes);
      expect(
        status4.sharpness,
        equals(Sharpness.medium),
      ); // Should default to medium

      // Test invalid/default ISO value (11)
      bytes[52] = 0x03; // 00000011 - bits 1-2 = 11 (invalid)
      final status5 = CameraStatus(bytes);
      expect(
        status5.iso,
        equals(IsoLimit.iso6400),
      ); // Should default to iso6400
    });

    test('parses one button mode from bit field correctly', () {
      final bytes = Uint8List(64);

      // Test one button off (bit 5 = 0)
      bytes[18] = 0x00;
      final statusOff = CameraStatus(bytes);
      expect(statusOff.oneButtonMode, equals(OneButton.off));

      // Test one button on (bit 5 = 1)
      bytes[18] = 0x08;
      final statusOn = CameraStatus(bytes);
      expect(statusOn.oneButtonMode, equals(OneButton.on));
    });

    test('parses video preview from bit field correctly', () {
      final bytes = Uint8List(64);

      // Test video preview off (bit 8 = 0)
      bytes[18] = 0x00;
      final statusOff = CameraStatus(bytes);
      expect(statusOff.videoPreview, equals(VideoPreview.off));

      // Test video preview on (bit 8 = 1)
      bytes[18] = 0x01;
      final statusOn = CameraStatus(bytes);
      expect(statusOn.videoPreview, equals(VideoPreview.on));
    });

    test('parses simultaneous video and photo correctly', () {
      final bytes = Uint8List(64);

      bytes[36] = 0x00;
      final statusOff = CameraStatus(bytes);
      expect(statusOff.simultaneousVideoAndPhoto, isFalse);

      bytes[36] = 0x01;
      final statusOn = CameraStatus(bytes);
      expect(statusOn.simultaneousVideoAndPhoto, isTrue);
    });

    test('handles multiple bit fields in same byte correctly', () {
      final bytes = Uint8List(64);

      // Test multiple flags in byte 18
      // Set all flags: PAL (0x20), Locate (0x40), OneButton (0x08), CameraOrientation (0x04), VideoPreview (0x01)
      bytes[18] = 0x6D; // 01101101
      final status = CameraStatus(bytes);

      expect(status.videoStandard, equals(VideoStandard.pal));
      expect(status.locateStatus, equals(Locate.on));
      expect(status.oneButtonMode, equals(OneButton.on));
      expect(status.orientation, equals(CameraOrientation.down));
      expect(status.videoPreview, equals(VideoPreview.on));
    });

    test('handles unknown enum values with defaults', () {
      final bytes = Uint8List(64);

      // Set invalid values that don't match any enum
      bytes[1] = 0xFF; // Invalid camera mode
      bytes[3] = 0xFF; // Invalid default mode
      bytes[4] = 0xFF; // Invalid spot meter
      bytes[5] = 0xFF; // Invalid timelapse interval
      bytes[6] = 0xFF; // Invalid auto power off
      bytes[7] = 0xFF; // Invalid FOV
      bytes[8] = 0xFF; // Invalid photo resolution
      bytes[16] = 0xFF; // Invalid volume
      bytes[17] = 0xFF; // Invalid LED
      bytes[32] = 0xFF; // Invalid burst rate
      bytes[33] = 0xFF; // Invalid continuous shot
      bytes[34] = 0xFF; // Invalid white balance
      bytes[37] = 0xFF; // Invalid loop video duration
      bytes[50] = 0xFF; // Invalid video resolution
      bytes[51] = 0xFF; // Invalid FPS
      bytes[53] = 0xFF; // Invalid exposure compensation

      final status = CameraStatus(bytes);

      // Should use defaults from orElse
      expect(status.cameraMode, equals(CameraMode.all.first));
      expect(status.defaultCameraMode, equals(DefaultCameraMode.all.first));
      expect(status.spotMeter, equals(SpotMeter.all.first));
      expect(status.timelapseInterval, equals(TimelapseInterval.all.first));
      expect(status.autoPowerOff, equals(AutoPowerOff.all.first));
      expect(status.fov, equals(Fov.all.first));
      expect(status.photoResolution, equals(PhotoResolution.all.first));
      expect(status.volume, equals(Volume.all.first));
      expect(status.ledsStatus, equals(Led.all.first));
      expect(status.burstRate, equals(BurstRate.all.first));
      expect(status.continuousShotMode, equals(ContinuousShot.all.first));
      expect(status.whiteBalance, equals(WhiteBalance.all.first));
      expect(status.loopVideoDuration, equals(LoopVideoDuration.all.first));
      expect(status.videoResolution, equals(VideoResolution.all.first));
      expect(status.fps, equals(Fps.all.first));
      expect(
        status.exposureCompensation,
        equals(ExposureCompensation.all.first),
      );
    });

    test('uses provided fallback camera mode for unknown mode value', () {
      final bytes = Uint8List(64);

      bytes[1] = 0xFF; // Invalid camera mode

      final status = CameraStatus(
        bytes,
        fallbackCameraMode: CameraMode.timelapseMode,
      );

      expect(status.cameraMode, equals(CameraMode.timelapseMode));
    });

    test('parses all integer fields correctly', () {
      final bytes = Uint8List(64);

      // Test recording progress (bytes 13-14)
      bytes[13] = 0x12; // High byte
      bytes[14] = 0x34; // Low byte (18*256 + 52 = 4660 seconds)

      // Test battery level
      bytes[19] = 0x03;

      // Test photos remaining (bytes 21-22)
      bytes[21] = 0x01;
      bytes[22] = 0xC8; // 1*256 + 200 = 456

      // Test photos taken (bytes 23-24)
      bytes[23] = 0x00;
      bytes[24] = 0x32; // 50

      // Test recording time remaining (bytes 25-26)
      bytes[25] = 0x00;
      bytes[26] = 0x3C; // 60 minutes

      // Test videos taken (bytes 27-28)
      bytes[27] = 0x00;
      bytes[28] = 0x0A; // 10

      final status = CameraStatus(bytes);

      expect(status.recordingProgress, equals(4660));
      expect(status.batteryLevel, equals(3));
      expect(status.photosRemaining, equals(456));
      expect(status.photosTaken, equals(50));
      expect(status.recordingTimeRemaining, equals(60));
      expect(status.videosTaken, equals(10));
    });

    test('handles maximum values for integer fields', () {
      final bytes = Uint8List(64);

      // Test with maximum 16-bit values
      bytes[13] = 0xFF;
      bytes[14] = 0xFF; // 65535
      bytes[21] = 0xFF;
      bytes[22] = 0xFF;
      bytes[23] = 0xFF;
      bytes[24] = 0xFF;
      bytes[25] = 0xFF;
      bytes[26] = 0xFF;
      bytes[27] = 0xFF;
      bytes[28] = 0xFF;

      final status = CameraStatus(bytes);

      expect(status.recordingProgress, equals(65535));
      expect(status.photosRemaining, equals(65535));
      expect(status.photosTaken, equals(65535));
      expect(status.recordingTimeRemaining, equals(65535));
      expect(status.videosTaken, equals(65535));
    });

    test('parses ProTune color profile correctly', () {
      final bytes = Uint8List(64);

      // Test GoPro color (bit 1 = 0)
      bytes[30] = 0x00;
      final statusGoPro = CameraStatus(bytes);
      expect(statusGoPro.colorProfile, equals(ColorProfile.goPro));

      // Test Flat color (bit 1 = 1)
      bytes[30] = 0x80;
      final statusFlat = CameraStatus(bytes);
      expect(statusFlat.colorProfile, equals(ColorProfile.flat));
    });
  });
}
