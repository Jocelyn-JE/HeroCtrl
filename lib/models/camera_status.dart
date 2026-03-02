import 'dart:typed_data';
import 'package:heroctrl/constants/gopro_action_enums.dart';
import 'package:heroctrl/constants/gopro_photo_enums.dart';
import 'package:heroctrl/constants/gopro_protune_enums.dart';
import 'package:heroctrl/constants/gopro_recording_enums.dart';
import 'package:heroctrl/constants/gopro_system_enums.dart';

class CameraStatus {
  final int cameraMode;
  final DefaultCameraMode defaultCameraMode;
  final SpotMeter spotMeter;
  final TimelapseInterval timelapseInterval;
  final AutoPowerOff autoPowerOff;
  final FOV fov;
  final PhotoResolution photoResolution;
  final int recordingProgress; // in seconds
  final Volume volume;
  final LED ledsStatus;
  final VideoStandard videoMode;
  final Locate locateStatus;
  final OneButton oneButtonMode;
  final Orientation orientation;
  final VideoPreview videoPreview;
  final int batteryLevel; // 0 - 3, need to call bl for percentage
  final int photosRemaining;
  final int photosTaken;
  final int recordingTimeRemaining; // in minutes
  final int videosTaken;
  final bool shutterStatus;
  final ColorProfile colorProfile;
  final ProTune protuneStatus;
  final LowLight lowLightMode;
  final BurstRate burstRate;
  final ContinuousShot continuousShotMode;
  final WhiteBalance whiteBalance;
  final bool simultaneousVideoAndPhoto;
  final LoopVideoDuration loopVideoDuration;
  final VideoResolution videoResolution;
  final FPS fps;
  final Sharpness sharpness;
  final ISOLimit iso;
  final ExposureCompensation exposureCompensation;

  static int _parseInt(int high, int low) {
    return (high << 8) | low;
  }

  // Video mode is the third bit of the byte starting from the left
  static VideoStandard _parseVideoStandard(int byte) {
    return (byte & 0x20) != 0 ? VideoStandard.pal : VideoStandard.ntsc;
  }

  // Locate status is the second bit of the byte starting from the left
  static Locate _parseLocateStatus(int byte) {
    return (byte & 0x40) != 0 ? Locate.on : Locate.off;
  }

  // One button mode is the fifth bit of the byte starting from the left
  static OneButton _parseOneButtonMode(int byte) {
    return (byte & 0x08) != 0 ? OneButton.on : OneButton.off;
  }

  // Orientation is the sixth bit of the byte starting from the left
  static Orientation _parseOrientation(int byte) {
    return (byte & 0x04) == 0 ? Orientation.up : Orientation.down;
  }

  // Video preview is the eighth bit of the byte starting from the left
  static VideoPreview _parseVideoPreview(int byte) {
    return (byte & 0x01) != 0 ? VideoPreview.on : VideoPreview.off;
  }

  // Sharpness is the fifth and sixth bits of the byte starting from the left
  static Sharpness _parseSharpness(int byte) {
    int sharpnessBits = (byte & 0x0C) >> 2;
    switch (sharpnessBits) {
      case 0:
        return Sharpness.low;
      case 1:
        return Sharpness.medium;
      case 2:
        return Sharpness.high;
      default:
        return Sharpness.medium;
    }
  }

  // ISO is the seventh and eighth bits of the byte starting from the left
  static ISOLimit _parseIso(int byte) {
    int isoBits = byte & 0x03;
    switch (isoBits) {
      case 0:
        return ISOLimit.iso6400;
      case 1:
        return ISOLimit.iso1600;
      case 2:
        return ISOLimit.iso400;
      default:
        return ISOLimit.iso6400;
    }
  }

  // Color profile is the first bit of the byte starting from the left
  static ColorProfile _parseColorProfile(int byte) {
    return (byte & 0x80) != 0 ? ColorProfile.flat : ColorProfile.goPro;
  }

  // Protune status is the seventh bit of the byte starting from the left
  static ProTune _parseProtuneStatus(int byte) {
    return (byte & 0x02) != 0 ? ProTune.on : ProTune.off;
  }

  // Low light mode is the second bit of the byte starting from the left
  static LowLight _parseLowLightMode(int byte) {
    return (byte & 0x40) != 0 ? LowLight.on : LowLight.off;
  }

  CameraStatus(Uint8List bytes)
    : cameraMode = bytes[1],
      defaultCameraMode = DefaultCameraMode.all.firstWhere(
        (mode) => mode.value == bytes[3],
        orElse: () => DefaultCameraMode.videoMode,
      ),
      spotMeter = SpotMeter.all.firstWhere(
        (meter) => meter.value == bytes[4],
        orElse: () => SpotMeter.off,
      ),
      timelapseInterval = TimelapseInterval.all.firstWhere(
        (interval) => interval.value == bytes[5],
        orElse: () => TimelapseInterval.halfASecond,
      ),
      autoPowerOff = AutoPowerOff.all.firstWhere(
        (powerOff) => powerOff.value == bytes[6],
        orElse: () => AutoPowerOff.never,
      ),
      fov = FOV.all.firstWhere(
        (f) => f.value == bytes[7],
        orElse: () => FOV.wide,
      ),
      photoResolution = PhotoResolution.all.firstWhere(
        (res) => res.value == bytes[8],
        orElse: () => PhotoResolution.res5MPmedium,
      ),
      recordingProgress = _parseInt(bytes[13], bytes[14]),
      volume = Volume.all.firstWhere(
        (vol) => vol.value == bytes[16],
        orElse: () => Volume.percent100,
      ),
      ledsStatus = LED.all.firstWhere(
        (led) => led.value == bytes[17],
        orElse: () => LED.off,
      ),
      videoMode = _parseVideoStandard(bytes[18]),
      locateStatus = _parseLocateStatus(bytes[18]),
      oneButtonMode = _parseOneButtonMode(bytes[18]),
      orientation = _parseOrientation(bytes[18]),
      videoPreview = _parseVideoPreview(bytes[18]),
      batteryLevel = bytes[19],
      photosRemaining = _parseInt(bytes[21], bytes[22]),
      photosTaken = _parseInt(bytes[23], bytes[24]),
      recordingTimeRemaining = _parseInt(bytes[25], bytes[26]),
      videosTaken = _parseInt(bytes[27], bytes[28]),
      shutterStatus = bytes[29] != 0,
      colorProfile = _parseColorProfile(bytes[30]),
      protuneStatus = _parseProtuneStatus(bytes[30]),
      lowLightMode = _parseLowLightMode(bytes[30]),
      burstRate = BurstRate.all.firstWhere(
        (rate) => rate.value == bytes[32],
        orElse: () => BurstRate.threePerSecond,
      ),
      continuousShotMode = ContinuousShot.all.firstWhere(
        (shot) => shot.value == bytes[33],
        orElse: () => ContinuousShot.off,
      ),
      whiteBalance = WhiteBalance.all.firstWhere(
        (wb) => wb.value == bytes[34],
        orElse: () => WhiteBalance.auto,
      ),
      simultaneousVideoAndPhoto = bytes[36] != 0,
      loopVideoDuration = LoopVideoDuration.all.firstWhere(
        (duration) => duration.value == bytes[37],
        orElse: () => LoopVideoDuration.off,
      ),
      videoResolution = VideoResolution.all.firstWhere(
        (res) => res.value == bytes[50],
        orElse: () => VideoResolution.wvga240fps,
      ),
      fps = FPS.all.firstWhere(
        (f) => f.value == bytes[51],
        orElse: () => FPS.fps30,
      ),
      sharpness = _parseSharpness(bytes[52]),
      iso = _parseIso(bytes[52]),
      exposureCompensation = ExposureCompensation.all.firstWhere(
        (ec) => ec.value == bytes[53],
        orElse: () => ExposureCompensation.zero,
      );
}
