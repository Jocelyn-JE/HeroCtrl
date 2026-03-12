import 'package:flutter/material.dart';
import 'package:heroctrl/gopro_settings/camera_setting.dart';
import 'package:heroctrl/gopro_settings/endpoints.dart';
import 'package:heroctrl/l10n/app_localizations.dart';

class OneButton extends CameraSetting {
  const OneButton._(super._value);

  static const OneButton off = OneButton._(0x00);
  static const OneButton on = OneButton._(0x01);

  static const List<OneButton> all = [off, on];

  @override
  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (value) {
      case 0x00:
        return l10n.volumeOff;
      case 0x01:
        return l10n.buttonOn;
      default:
        return toHex(value);
    }
  }

  static OneButton fromByte(int byte) => enumFromByte(byte, all);
}
