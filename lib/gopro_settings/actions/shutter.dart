import 'package:flutter/material.dart';
import 'package:heroctrl/gopro_settings/camera_setting.dart';
import 'package:heroctrl/gopro_settings/endpoints.dart';
import 'package:heroctrl/l10n/app_localizations.dart';

class Shutter extends CameraSetting {
  const Shutter._(super._value);

  static const Shutter stop = Shutter._(0x00);
  static const Shutter start = Shutter._(0x01);

  static const List<Shutter> all = [stop, start];

  @override
  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (value) {
      case 0x00:
        return l10n.shutterStop;
      case 0x01:
        return l10n.shutterStart;
      default:
        return toHex(value);
    }
  }

  static Shutter fromByte(int byte) => enumFromByte(byte, all);
}
