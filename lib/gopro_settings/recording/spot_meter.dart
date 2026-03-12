import 'package:flutter/material.dart';
import 'package:heroctrl/gopro_settings/camera_setting.dart';
import 'package:heroctrl/gopro_settings/endpoints.dart';
import 'package:heroctrl/l10n/app_localizations.dart';

class SpotMeter extends CameraSetting {
  const SpotMeter._(super._value);

  static const SpotMeter off = SpotMeter._(0x00);
  static const SpotMeter on = SpotMeter._(0x01);

  static const List<SpotMeter> all = [off, on];

  @override
  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (value) {
      case 0x00:
        return l10n.spotMeterOff;
      case 0x01:
        return l10n.spotMeterOn;
      default:
        return toHex(value);
    }
  }

  static SpotMeter fromByte(int byte) => enumFromByte(byte, all);
}
