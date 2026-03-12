import 'package:flutter/material.dart';
import 'package:heroctrl/gopro_settings/camera_setting.dart';
import 'package:heroctrl/gopro_settings/endpoints.dart';
import 'package:heroctrl/l10n/app_localizations.dart';

class BurstRate extends CameraSetting {
  const BurstRate._(super.value);

  static const BurstRate threePerSecond = BurstRate._(0x00);
  static const BurstRate fivePerSecond = BurstRate._(0x01);
  static const BurstRate tenPerSecond = BurstRate._(0x02);
  static const BurstRate tenPerTwoSeconds = BurstRate._(0x03);
  static const BurstRate thirtyPerSecond = BurstRate._(0x04);
  static const BurstRate thirtyPerTwoSeconds = BurstRate._(0x05);
  static const BurstRate thirtyPerThreeSeconds = BurstRate._(0x06);

  static const List<BurstRate> all = [
    threePerSecond,
    fivePerSecond,
    tenPerSecond,
    tenPerTwoSeconds,
    thirtyPerSecond,
    thirtyPerTwoSeconds,
    thirtyPerThreeSeconds,
  ];

  @override
  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (value) {
      case 0x00:
        return l10n.burstRate3PerSec;
      case 0x01:
        return l10n.burstRate5PerSec;
      case 0x02:
        return l10n.burstRate10PerSec;
      case 0x03:
        return l10n.burstRate10Per2Sec;
      case 0x04:
        return l10n.burstRate30PerSec;
      case 0x05:
        return l10n.burstRate30Per2Sec;
      case 0x06:
        return l10n.burstRate30Per3Sec;
      default:
        return toHex(value);
    }
  }

  static BurstRate fromByte(int byte) => enumFromByte(byte, all);
}
