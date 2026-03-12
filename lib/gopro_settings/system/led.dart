import 'package:flutter/material.dart';
import 'package:heroctrl/gopro_settings/camera_setting.dart';
import 'package:heroctrl/gopro_settings/endpoints.dart';
import 'package:heroctrl/l10n/app_localizations.dart';

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
