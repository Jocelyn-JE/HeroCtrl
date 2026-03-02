import 'dart:typed_data';
import 'package:heroctrl/constants/gopro_endpoints.dart';

class CameraStatus {
  final int cameraMode;
  final int defaultCameraMode;
  final bool spotMeter;
  final int timelapseInterval;
  final int autoPowerOff;
  final int fov;
  final int photoResolution;
  final int recordingProgress; // in seconds
  final int volume;
  final int ledsStatus;
  final int videoMode;
  final bool locateStatus;
  final bool oneButtonMode;
  final int orientation;
  final int videoPreview;
  final int batteryLevel; // 0 - 3, need to call bl for percentage
  final int photosRemaining;
  final int photosTaken;
  final int recordingTimeRemaining; // in minutes
  final int videosTaken;
  final bool shutterStatus;
  final int colorProfile;
  final bool protuneStatus;
  final bool lowLightMode;
  final int burstRate;
  final int continuousShotMode;
  final int whiteBalance;
  final int simultaneousVideoAndPhoto;
  final int loopVideoDuration;
  final int videoResolution;
  final int fps;
  final int sharpness;
  final int iso;
  final int exposureCompensation;

  static int _parseInt(int high, int low) {
    return (high << 8) | low;
  }

  // Video mode is the third bit of the byte starting from the left
  static int _parseVideoMode(int byte) {
    return (byte & 0x20) != 0 ? VideoModes.pal : VideoModes.ntsc;
  }

  // Locate status is the second bit of the byte starting from the left
  static int _parseLocateStatus(int byte) {
    return (byte & 0x40) != 0 ? Locate.on : Locate.off;
  }

  // One button mode is the fifth bit of the byte starting from the left
  static int _parseOneButtonMode(int byte) {
    return (byte & 0x08) != 0 ? OneButton.on : OneButton.off;
  }

  // Orientation is the sixth bit of the byte starting from the left
  static int _parseOrientation(int byte) {
    return (byte & 0x04) == 0 ? Orientation.up : Orientation.down;
  }

  // Video preview is the eighth bit of the byte starting from the left
  static int _parseVideoPreview(int byte) {
    return (byte & 0x01) != 0 ? VideoPreview.on : VideoPreview.off;
  }

  // Sharpness is the fifth and sixth bits of the byte starting from the left
  static int _parseSharpness(int byte) {
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
  static int _parseIso(int byte) {
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
  static int _parseColorProfile(int byte) {
    return (byte & 0x80) != 0 ? ColorProfile.flat : ColorProfile.goPro;
  }

  // Protune status is the seventh bit of the byte starting from the left
  static int _parseProtuneStatus(int byte) {
    return (byte & 0x02) != 0 ? ProTune.on : ProTune.off;
  }

  // Low light mode is the second bit of the byte starting from the left
  static int _parseLowLightMode(int byte) {
    return (byte & 0x40) != 0 ? LowLight.on : LowLight.off;
  }

  CameraStatus(Uint8List bytes)
    : cameraMode = bytes[1],
      defaultCameraMode = bytes[3],
      spotMeter = bytes[4] != 0,
      timelapseInterval = bytes[5],
      autoPowerOff = bytes[6],
      fov = bytes[7],
      photoResolution = bytes[8],
      recordingProgress = _parseInt(bytes[13], bytes[14]),
      volume = bytes[16],
      ledsStatus = bytes[17],
      videoMode = _parseVideoMode(bytes[18]),
      locateStatus = _parseLocateStatus(bytes[18]) == Locate.on,
      oneButtonMode = _parseOneButtonMode(bytes[18]) == OneButton.on,
      orientation = _parseOrientation(bytes[18]),
      videoPreview = _parseVideoPreview(bytes[18]),
      batteryLevel = bytes[19],
      photosRemaining = _parseInt(bytes[21], bytes[22]),
      photosTaken = _parseInt(bytes[23], bytes[24]),
      recordingTimeRemaining = _parseInt(bytes[25], bytes[26]),
      videosTaken = _parseInt(bytes[27], bytes[28]),
      shutterStatus = bytes[29] != 0,
      colorProfile = _parseColorProfile(bytes[30]),
      protuneStatus = _parseProtuneStatus(bytes[30]) == ProTune.on,
      lowLightMode = _parseLowLightMode(bytes[30]) == LowLight.on,
      burstRate = bytes[32],
      continuousShotMode = bytes[33],
      whiteBalance = bytes[34],
      simultaneousVideoAndPhoto = bytes[36],
      loopVideoDuration = bytes[37],
      videoResolution = bytes[50],
      fps = bytes[51],
      sharpness = _parseSharpness(bytes[52]),
      iso = _parseIso(bytes[52]),
      exposureCompensation = bytes[53];
}
