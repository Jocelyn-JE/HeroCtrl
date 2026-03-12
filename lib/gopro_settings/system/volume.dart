import 'package:flutter/material.dart';
import 'package:heroctrl/gopro_settings/camera_setting.dart';
import 'package:heroctrl/gopro_settings/endpoints.dart';
import 'package:heroctrl/l10n/app_localizations.dart';

class Volume extends CameraSetting {
  const Volume._(super._value);

  static const Volume mute = Volume._(0x00);
  static const Volume percent70 = Volume._(0x01);
  static const Volume percent100 = Volume._(0x02);

  static const List<Volume> all = [mute, percent70, percent100];

  @override
  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (value) {
      case 0x00:
        return l10n.volumeOff;
      case 0x01:
        return l10n.volumeLow;
      case 0x02:
        return l10n.volumeHigh;
      default:
        return toHex(value);
    }
  }

  static Volume fromByte(int byte) => enumFromByte(byte, all);
}
