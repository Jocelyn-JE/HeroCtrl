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
        return l10n.powerOff;
      case 0x01:
        return l10n.powerOn;
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
        return l10n.shutterStop;
      case 0x01:
        return l10n.shutterStart;
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
        return l10n.previewOff;
      case 0x02:
        return l10n.previewOn;
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
        return l10n.locateOff;
      case 0x01:
        return l10n.locateOn;
      default:
        return toHex(_value);
    }
  }
}

class CameraMode {
  final int _value;
  final IconData _icon;
  const CameraMode._(this._value, this._icon);

  int get value => _value;
  IconData get icon => _icon;

  static const CameraMode videoMode = CameraMode._(0x00, Icons.videocam);
  static const CameraMode photoMode = CameraMode._(0x01, Icons.camera_alt);
  static const CameraMode burstMode = CameraMode._(0x02, Icons.burst_mode);
  static const CameraMode timelapseMode = CameraMode._(0x03, Icons.schedule);
  static const CameraMode hdmiMode = CameraMode._(0x05, Icons.tv);
  static const CameraMode settings = CameraMode._(0x07, Icons.settings);

  static const List<CameraMode> all = [
    videoMode,
    photoMode,
    burstMode,
    timelapseMode,
    hdmiMode,
    settings,
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
      case 0x03:
        return l10n.cameraModeTimelapse;
      case 0x05:
        return l10n.cameraModeHdmi;
      case 0x07:
        return l10n.cameraModeSettings;
      default:
        return toHex(_value);
    }
  }
}
