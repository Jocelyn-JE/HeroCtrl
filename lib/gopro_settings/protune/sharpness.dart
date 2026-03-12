import 'package:flutter/material.dart';
import 'package:heroctrl/gopro_settings/camera_setting.dart';
import 'package:heroctrl/gopro_settings/endpoints.dart';
import 'package:heroctrl/l10n/app_localizations.dart';

class Sharpness extends CameraSetting {
  const Sharpness._(super.value);

  static const Sharpness high = Sharpness._(0x00);
  static const Sharpness medium = Sharpness._(0x01);
  static const Sharpness low = Sharpness._(0x02);

  static const List<Sharpness> all = [high, medium, low];

  @override
  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (value) {
      case 0x00:
        return l10n.sharpnessHigh;
      case 0x01:
        return l10n.sharpnessMedium;
      case 0x02:
        return l10n.sharpnessLow;
      default:
        return toHex(value);
    }
  }

  static Sharpness fromByte(int byte) => enumFromByte(byte, all);
}
