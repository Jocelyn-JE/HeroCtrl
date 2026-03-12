import 'package:flutter/material.dart';
import 'package:heroctrl/constants/enum_class.dart';
import 'package:heroctrl/constants/gopro_endpoints.dart';
import 'package:heroctrl/constants/gopro_recording_enums.dart';
import 'package:heroctrl/l10n/app_localizations.dart';

class Volume extends EnumClass {
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

class LED extends EnumClass {
  const LED._(super._value);

  static const LED off = LED._(0x00);
  static const LED twoLeds = LED._(0x01);
  static const LED fourLeds = LED._(0x02);

  static const List<LED> all = [off, twoLeds, fourLeds];

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

class DefaultCameraMode extends EnumClass {
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

class VideoStandard extends EnumClass {
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
      FPS.fps15,
      FPS.fps12,
      FPS.fps24,
      FPS.fps30,
      FPS.fps48,
      FPS.fps60,
      FPS.fps100,
      FPS.fps120,
      FPS.fps240,
    ],
    pal: [
      FPS.fps12_5,
      FPS.fps12,
      FPS.fps24,
      FPS.fps25,
      FPS.fps48,
      FPS.fps50,
      FPS.fps100,
      FPS.fps240,
    ],
  };

  static VideoStandard fromByte(int byte) => enumFromByte(byte, all);
}

class Orientation extends EnumClass {
  const Orientation._(super._value);

  static const Orientation up = Orientation._(0x00);
  static const Orientation down = Orientation._(0x01);

  static const List<Orientation> all = [up, down];

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

  static Orientation fromByte(int byte) => enumFromByte(byte, all);
}

class OneButton extends EnumClass {
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

class AutoPowerOff extends EnumClass {
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
