import 'package:flutter/material.dart';
import 'package:heroctrl/gopro_settings/camera_setting.dart';
import 'package:heroctrl/gopro_settings/endpoints.dart';
import 'package:heroctrl/l10n/app_localizations.dart';

class LowLight extends CameraSetting {
  const LowLight._(super._value);

  static const LowLight off = LowLight._(0x00);
  static const LowLight on = LowLight._(0x01);

  static const List<LowLight> all = [off, on];

  @override
  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (value) {
      case 0x00:
        return l10n.lowLightOff;
      case 0x01:
        return l10n.lowLightOn;
      default:
        return toHex(value);
    }
  }

  static LowLight fromByte(int byte) => enumFromByte(byte, all);
}
