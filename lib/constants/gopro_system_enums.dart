import 'package:flutter/material.dart';
import 'package:heroctrl/constants/gopro_endpoints.dart';
import 'package:heroctrl/constants/gopro_recording_enums.dart';
import 'package:heroctrl/l10n/app_localizations.dart';

class Volume {
  final int _value;

  const Volume._(this._value);

  int get value => _value;

  static const Volume mute = Volume._(0x00);
  static const Volume percent70 = Volume._(0x01);
  static const Volume percent100 = Volume._(0x02);

  static const List<Volume> all = [mute, percent70, percent100];

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Volume && _value == other._value;

  @override
  int get hashCode => _value.hashCode;

  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (_value) {
      case 0x00:
        return l10n.volumeOff;
      case 0x01:
        return l10n.volumeLow;
      case 0x02:
        return l10n.volumeHigh;
      default:
        return toHex(_value);
    }
  }
}

class LED {
  final int _value;

  const LED._(this._value);

  int get value => _value;

  static const LED off = LED._(0x00);
  static const LED twoLeds = LED._(0x01);
  static const LED fourLeds = LED._(0x02);

  static const List<LED> all = [off, twoLeds, fourLeds];

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is LED && _value == other._value;

  @override
  int get hashCode => _value.hashCode;

  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (_value) {
      case 0x00:
        return l10n.ledOff;
      case 0x01:
        return l10n.ledTwo;
      case 0x02:
        return l10n.ledFour;
      default:
        return toHex(_value);
    }
  }
}

class DefaultCameraMode {
  final int _value;
  const DefaultCameraMode._(this._value);

  int get value => _value;

  static const DefaultCameraMode videoMode = DefaultCameraMode._(0x00);
  static const DefaultCameraMode photoMode = DefaultCameraMode._(0x01);
  static const DefaultCameraMode burstMode = DefaultCameraMode._(0x02);
  static const DefaultCameraMode timeLapseMode = DefaultCameraMode._(0x03);

  static const List<DefaultCameraMode> all = [
    videoMode,
    photoMode,
    burstMode,
    timeLapseMode,
  ];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DefaultCameraMode && _value == other._value;

  @override
  int get hashCode => _value.hashCode;

  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (_value) {
      case 0x00:
        return l10n.defaultModeVideo;
      case 0x01:
        return l10n.defaultModePhoto;
      case 0x02:
        return l10n.defaultModeBurst;
      case 0x03:
        return l10n.defaultModeTimeLapse;
      default:
        return toHex(_value);
    }
  }
}

class VideoStandard {
  final int _value;
  const VideoStandard._(this._value);

  int get value => _value;

  static const VideoStandard ntsc = VideoStandard._(0x00);
  static const VideoStandard pal = VideoStandard._(0x01);

  static const List<VideoStandard> all = [ntsc, pal];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VideoStandard && _value == other._value;

  @override
  int get hashCode => _value.hashCode;

  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (_value) {
      case 0x00:
        return l10n.videoStandardNtsc;
      case 0x01:
        return l10n.videoStandardPal;
      default:
        return toHex(_value);
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
}

class Orientation {
  final int _value;
  const Orientation._(this._value);

  int get value => _value;

  static const Orientation up = Orientation._(0x00);
  static const Orientation down = Orientation._(0x01);

  static const List<Orientation> all = [up, down];

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Orientation && _value == other._value;

  @override
  int get hashCode => _value.hashCode;

  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (_value) {
      case 0x00:
        return l10n.orientationUp;
      case 0x01:
        return l10n.orientationDown;
      default:
        return toHex(_value);
    }
  }
}

class OneButton {
  final int _value;
  const OneButton._(this._value);

  int get value => _value;

  static const OneButton off = OneButton._(0x00);
  static const OneButton on = OneButton._(0x01);

  static const List<OneButton> all = [off, on];

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is OneButton && _value == other._value;

  @override
  int get hashCode => _value.hashCode;

  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (_value) {
      case 0x00:
        return l10n.volumeOff;
      case 0x01:
        return l10n.buttonOn;
      default:
        return toHex(_value);
    }
  }
}

class AutoPowerOff {
  final int _value;
  const AutoPowerOff._(this._value);

  int get value => _value;

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
  bool operator ==(Object other) =>
      identical(this, other) || other is AutoPowerOff && _value == other._value;

  @override
  int get hashCode => _value.hashCode;

  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (_value) {
      case 0x00:
        return l10n.autoPowerOffNever;
      case 0x01:
        return l10n.autoPowerOff1Min;
      case 0x02:
        return l10n.autoPowerOff2Min;
      case 0x03:
        return l10n.autoPowerOff5Min;
      default:
        return toHex(_value);
    }
  }
}
