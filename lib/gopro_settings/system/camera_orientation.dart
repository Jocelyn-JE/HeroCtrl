import 'package:flutter/material.dart';
import 'package:heroctrl/gopro_settings/camera_setting.dart';
import 'package:heroctrl/gopro_settings/endpoints.dart';
import 'package:heroctrl/l10n/app_localizations.dart';

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
