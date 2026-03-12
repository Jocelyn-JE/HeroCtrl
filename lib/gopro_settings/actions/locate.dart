import 'package:flutter/material.dart';
import 'package:heroctrl/gopro_settings/camera_setting.dart';
import 'package:heroctrl/gopro_settings/endpoints.dart';
import 'package:heroctrl/l10n/app_localizations.dart';

class Locate extends CameraSetting {
  const Locate._(super._value);

  static const Locate off = Locate._(0x00);
  static const Locate on = Locate._(0x01);

  static const List<Locate> all = [off, on];

  @override
  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (value) {
      case 0x00:
        return l10n.locateOff;
      case 0x01:
        return l10n.locateOn;
      default:
        return toHex(value);
    }
  }

  static Locate fromByte(int byte) => enumFromByte(byte, all);
}
