import 'package:flutter/material.dart';
import 'package:heroctrl/gopro_settings/camera_setting.dart';
import 'package:heroctrl/gopro_settings/endpoints.dart';
import 'package:heroctrl/l10n/app_localizations.dart';

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
