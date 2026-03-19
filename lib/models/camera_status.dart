import 'dart:typed_data';
import 'package:heroctrl/gopro_settings/actions/actions.dart';
import 'package:heroctrl/gopro_settings/photo/photo.dart';
import 'package:heroctrl/gopro_settings/protune/protune.dart';
import 'package:heroctrl/gopro_settings/recording/recording.dart';
import 'package:heroctrl/gopro_settings/system/system.dart';

class CameraStatus {
  final CameraMode cameraMode;
  final DefaultCameraMode defaultCameraMode;
  final SpotMeter spotMeter;
  final TimelapseInterval timelapseInterval;
  final AutoPowerOff autoPowerOff;
  final Fov fov;
  final PhotoResolution photoResolution;
  final int recordingProgress; // in seconds
  final Volume volume;
  final Led ledsStatus;
  final VideoStandard videoStandard;
  final Locate locateStatus;
  final OneButton oneButtonMode;
  final CameraOrientation orientation;
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
  final Fps fps;
  final Sharpness sharpness;
  final IsoLimit iso;
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

  // CameraOrientation is the sixth bit of the byte starting from the left
  static CameraOrientation _parseCameraOrientation(int byte) {
    return (byte & 0x04) == 0 ? CameraOrientation.up : CameraOrientation.down;
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
        return Sharpness.high;
      case 1:
        return Sharpness.medium;
      case 2:
        return Sharpness.low;
      default:
        return Sharpness.high;
    }
  }

  // ISO is the seventh and eighth bits of the byte starting from the left
  static IsoLimit _parseIso(int byte) {
    int isoBits = byte & 0x03;
    switch (isoBits) {
      case 0:
        return IsoLimit.iso6400;
      case 1:
        return IsoLimit.iso1600;
      case 2:
        return IsoLimit.iso400;
      default:
        return IsoLimit.iso6400;
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

  CameraStatus(Uint8List bytes, {CameraMode? fallbackCameraMode})
    : cameraMode = CameraMode.fromByte(bytes[1], fallbackCameraMode),
      defaultCameraMode = DefaultCameraMode.fromByte(bytes[3]),
      spotMeter = SpotMeter.fromByte(bytes[4]),
      timelapseInterval = TimelapseInterval.fromByte(bytes[5]),
      autoPowerOff = AutoPowerOff.fromByte(bytes[6]),
      fov = Fov.fromByte(bytes[7]),
      photoResolution = PhotoResolution.fromByte(bytes[8]),
      recordingProgress = _parseInt(bytes[13], bytes[14]),
      volume = Volume.fromByte(bytes[16]),
      ledsStatus = Led.fromByte(bytes[17]),
      videoStandard = _parseVideoStandard(bytes[18]),
      locateStatus = _parseLocateStatus(bytes[18]),
      oneButtonMode = _parseOneButtonMode(bytes[18]),
      orientation = _parseCameraOrientation(bytes[18]),
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
      burstRate = BurstRate.fromByte(bytes[32]),
      continuousShotMode = ContinuousShot.fromByte(bytes[33]),
      whiteBalance = WhiteBalance.fromByte(bytes[34]),
      simultaneousVideoAndPhoto = bytes[36] != 0,
      loopVideoDuration = LoopVideoDuration.fromByte(bytes[37]),
      videoResolution = VideoResolution.fromByte(bytes[50]),
      fps = Fps.fromByte(bytes[51]),
      sharpness = _parseSharpness(bytes[52]),
      iso = _parseIso(bytes[52]),
      exposureCompensation = ExposureCompensation.fromByte(bytes[53]);
}
