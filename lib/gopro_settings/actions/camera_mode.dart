import 'package:flutter/material.dart';
import 'package:heroctrl/gopro_settings/camera_setting.dart';
import 'package:heroctrl/gopro_settings/endpoints.dart';
import 'package:heroctrl/l10n/app_localizations.dart';

class CameraMode extends CameraSetting {
  final IconData _icon;
  const CameraMode._(super._value, this._icon);

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
        return l10n.cameraModeTimelapse;
      case 0x05:
        return l10n.cameraModeHdmi;
      case 0x07:
        return l10n.cameraModeSettings;
      default:
        return toHex(value);
    }
  }

  static CameraMode fromByte(int byte, CameraMode? fallbackCameraMode) {
    return CameraMode.all.firstWhere(
      (mode) => mode.value == byte,
      orElse: () => fallbackCameraMode ?? CameraMode.all.first,
    );
  }
}
