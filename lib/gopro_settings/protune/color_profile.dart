import 'package:flutter/material.dart';
import 'package:heroctrl/gopro_settings/camera_setting.dart';
import 'package:heroctrl/gopro_settings/endpoints.dart';
import 'package:heroctrl/l10n/app_localizations.dart';

class ColorProfile extends CameraSetting {
  const ColorProfile._(super.value);

  static const ColorProfile goPro = ColorProfile._(0x00);
  static const ColorProfile flat = ColorProfile._(0x01);

  static const List<ColorProfile> all = [goPro, flat];

  @override
  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (value) {
      case 0x00:
        return l10n.colorProfileGoPro;
      case 0x01:
        return l10n.colorProfileFlat;
      default:
        return toHex(value);
    }
  }

  static ColorProfile fromByte(int byte) => enumFromByte(byte, all);
}
