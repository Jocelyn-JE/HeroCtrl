import 'package:flutter/material.dart';
import 'package:heroctrl/gopro_settings/camera_setting.dart';
import 'package:heroctrl/gopro_settings/endpoints.dart';
import 'package:heroctrl/l10n/app_localizations.dart';

class Power extends CameraSetting {
  const Power._(super._value);

  static const Power off = Power._(0x00);
  static const Power on = Power._(0x01);

  static const List<Power> all = [off, on];

  @override
  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (value) {
      case 0x00:
        return l10n.powerOff;
      case 0x01:
        return l10n.powerOn;
      default:
        return toHex(value);
    }
  }

  static Power fromByte(int byte) => enumFromByte(byte, all);
}
