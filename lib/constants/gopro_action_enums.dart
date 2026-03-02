import 'package:flutter/material.dart';
import 'package:heroctrl/constants/gopro_endpoints.dart';
import 'package:heroctrl/l10n/app_localizations.dart';

class Power {
  final int _value;
  const Power._(this._value);

  int get value => _value;

  static const Power off = Power._(0x00);
  static const Power on = Power._(0x01);

  static const List<Power> all = [off, on];

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Power && _value == other._value;

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

class Shutter {
  final int _value;
  const Shutter._(this._value);

  int get value => _value;

  static const Shutter stop = Shutter._(0x00);
  static const Shutter start = Shutter._(0x01);

  static const List<Shutter> all = [stop, start];

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Shutter && _value == other._value;

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

class VideoPreview {
  final int _value;
  const VideoPreview._(this._value);

  int get value => _value;

  static const VideoPreview off = VideoPreview._(0x00);
  static const VideoPreview on = VideoPreview._(0x02);

  static const List<VideoPreview> all = [off, on];

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is VideoPreview && _value == other._value;

  @override
  int get hashCode => _value.hashCode;

  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (_value) {
      case 0x00:
        return l10n.volumeOff;
      case 0x02:
        return l10n.buttonOn;
      default:
        return toHex(_value);
    }
  }
}

class Locate {
  final int _value;
  const Locate._(this._value);

  int get value => _value;

  static const Locate off = Locate._(0x00);
  static const Locate on = Locate._(0x01);

  static const List<Locate> all = [off, on];

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Locate && _value == other._value;

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

class CameraMode {
  final int _value;
  const CameraMode._(this._value);

  int get value => _value;

  static const CameraMode videoMode = CameraMode._(0x00);
  static const CameraMode photoMode = CameraMode._(0x01);
  static const CameraMode burstMode = CameraMode._(0x02);
  static const CameraMode timerMode = CameraMode._(0x04);
  static const CameraMode hdmiMode = CameraMode._(0x05);

  static const List<CameraMode> all = [
    videoMode,
    photoMode,
    burstMode,
    timerMode,
    hdmiMode,
  ];

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is CameraMode && _value == other._value;

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
      case 0x04:
        return l10n.cameraModeTimer;
      case 0x05:
        return l10n.cameraModeHdmi;
      default:
        return toHex(_value);
    }
  }
}
