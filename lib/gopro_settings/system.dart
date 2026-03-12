import 'package:flutter/material.dart';
import 'package:heroctrl/gopro_settings/camera_setting.dart';
import 'package:heroctrl/gopro_settings/endpoints.dart';
import 'package:heroctrl/gopro_settings/recording.dart';
import 'package:heroctrl/l10n/app_localizations.dart';

class Volume extends CameraSetting {
  const Volume._(super._value);

  static const Volume mute = Volume._(0x00);
  static const Volume percent70 = Volume._(0x01);
  static const Volume percent100 = Volume._(0x02);

  static const List<Volume> all = [mute, percent70, percent100];

  @override
  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (value) {
      case 0x00:
        return l10n.volumeOff;
      case 0x01:
        return l10n.volumeLow;
      case 0x02:
        return l10n.volumeHigh;
      default:
        return toHex(value);
    }
  }

  static Volume fromByte(int byte) => enumFromByte(byte, all);
}

class Led extends CameraSetting {
  const Led._(super._value);

  static const Led off = Led._(0x00);
  static const Led twoLeds = Led._(0x01);
  static const Led fourLeds = Led._(0x02);

  static const List<Led> all = [off, twoLeds, fourLeds];

  @override
  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (value) {
      case 0x00:
        return l10n.ledOff;
      case 0x01:
        return l10n.ledTwo;
      case 0x02:
        return l10n.ledFour;
      default:
        return toHex(value);
    }
  }

  static Led fromByte(int byte) => enumFromByte(byte, all);
}

class DefaultCameraMode extends CameraSetting {
  const DefaultCameraMode._(super._value);

  static const DefaultCameraMode videoMode = DefaultCameraMode._(0x00);
  static const DefaultCameraMode photoMode = DefaultCameraMode._(0x01);
  static const DefaultCameraMode burstMode = DefaultCameraMode._(0x02);
  static const DefaultCameraMode timelapseMode = DefaultCameraMode._(0x03);

  static const List<DefaultCameraMode> all = [
    videoMode,
    photoMode,
    burstMode,
    timelapseMode,
  ];

  @override
  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (value) {
      case 0x00:
        return l10n.defaultModeVideo;
      case 0x01:
        return l10n.defaultModePhoto;
      case 0x02:
        return l10n.defaultModeBurst;
      case 0x03:
        return l10n.defaultModeTimelapse;
      default:
        return toHex(value);
    }
  }

  static DefaultCameraMode fromByte(int byte) => enumFromByte(byte, all);
}

class VideoStandard extends CameraSetting {
  const VideoStandard._(super._value);

  static const VideoStandard ntsc = VideoStandard._(0x00);
  static const VideoStandard pal = VideoStandard._(0x01);

  static const List<VideoStandard> all = [ntsc, pal];

  @override
  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (value) {
      case 0x00:
        return l10n.videoStandardNtsc;
      case 0x01:
        return l10n.videoStandardPal;
      default:
        return toHex(value);
    }
  }

  static final videoStandardFrameRates = {
    ntsc: [
      Fps.fps15,
      Fps.fps12,
      Fps.fps24,
      Fps.fps30,
      Fps.fps48,
      Fps.fps60,
      Fps.fps100,
      Fps.fps120,
      Fps.fps240,
    ],
    pal: [
      Fps.fps12_5,
      Fps.fps12,
      Fps.fps24,
      Fps.fps25,
      Fps.fps48,
      Fps.fps50,
      Fps.fps100,
      Fps.fps240,
    ],
  };

  static VideoStandard fromByte(int byte) => enumFromByte(byte, all);
}

class CameraOrientation extends CameraSetting {
  const CameraOrientation._(super._value);

  static const CameraOrientation up = CameraOrientation._(0x00);
  static const CameraOrientation down = CameraOrientation._(0x01);

  static const List<CameraOrientation> all = [up, down];

  @override
  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (value) {
      case 0x00:
        return l10n.orientationUp;
      case 0x01:
        return l10n.orientationDown;
      default:
        return toHex(value);
    }
  }

  static CameraOrientation fromByte(int byte) => enumFromByte(byte, all);
}

class OneButton extends CameraSetting {
  const OneButton._(super._value);

  static const OneButton off = OneButton._(0x00);
  static const OneButton on = OneButton._(0x01);

  static const List<OneButton> all = [off, on];

  @override
  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (value) {
      case 0x00:
        return l10n.volumeOff;
      case 0x01:
        return l10n.buttonOn;
      default:
        return toHex(value);
    }
  }

  static OneButton fromByte(int byte) => enumFromByte(byte, all);
}

class AutoPowerOff extends CameraSetting {
  const AutoPowerOff._(super._value);

  static const AutoPowerOff never = AutoPowerOff._(0x00);
  static const AutoPowerOff after1Minute = AutoPowerOff._(0x01);
  static const AutoPowerOff after2Minutes = AutoPowerOff._(0x02);
  static const AutoPowerOff after5Minutes = AutoPowerOff._(0x03);

  static const List<AutoPowerOff> all = [
    never,
    after1Minute,
    after2Minutes,
    after5Minutes,
  ];

  @override
  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (value) {
      case 0x00:
        return l10n.autoPowerOffNever;
      case 0x01:
        return l10n.autoPowerOff1Min;
      case 0x02:
        return l10n.autoPowerOff2Min;
      case 0x03:
        return l10n.autoPowerOff5Min;
      default:
        return toHex(value);
    }
  }

  static AutoPowerOff fromByte(int byte) => enumFromByte(byte, all);
}
