import 'package:flutter/material.dart';
import 'package:heroctrl/gopro_settings/camera_setting.dart';
import 'package:heroctrl/gopro_settings/endpoints.dart';
import 'package:heroctrl/l10n/app_localizations.dart';

class IsoLimit extends CameraSetting {
  const IsoLimit._(super.value);

  static const IsoLimit iso6400 = IsoLimit._(0x00);
  static const IsoLimit iso1600 = IsoLimit._(0x01);
  static const IsoLimit iso400 = IsoLimit._(0x02);

  static const List<IsoLimit> all = [iso6400, iso1600, iso400];

  @override
  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (value) {
      case 0x00:
        return l10n.isoLimit6400;
      case 0x01:
        return l10n.isoLimit1600;
      case 0x02:
        return l10n.isoLimit400;
      default:
        return toHex(value);
    }
  }

  static IsoLimit fromByte(int byte) => enumFromByte(byte, all);
}
