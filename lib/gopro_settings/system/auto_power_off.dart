import 'package:flutter/material.dart';
import 'package:heroctrl/gopro_settings/camera_setting.dart';
import 'package:heroctrl/gopro_settings/endpoints.dart';
import 'package:heroctrl/l10n/app_localizations.dart';

class AutoPowerOff extends CameraSetting {
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
