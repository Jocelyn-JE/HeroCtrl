import 'package:flutter/material.dart';
import 'package:heroctrl/gopro_settings/camera_setting.dart';
import 'package:heroctrl/gopro_settings/endpoints.dart';
import 'package:heroctrl/l10n/app_localizations.dart';

class ProTune extends CameraSetting {
  const ProTune._(super.value);

  static const ProTune off = ProTune._(0x00);
  static const ProTune on = ProTune._(0x01);

  static const List<ProTune> all = [off, on];

  @override
  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (value) {
      case 0x00:
        return l10n.protuneOff;
      case 0x01:
        return l10n.protuneOn;
      default:
        return toHex(value);
    }
  }

  static ProTune fromByte(int byte) => enumFromByte(byte, all);
}
