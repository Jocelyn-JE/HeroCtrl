import 'package:flutter/material.dart';
import 'package:heroctrl/gopro_settings/camera_setting.dart';
import 'package:heroctrl/gopro_settings/endpoints.dart';
import 'package:heroctrl/l10n/app_localizations.dart';

class WhiteBalance extends CameraSetting {
  const WhiteBalance._(super.value);

  static const WhiteBalance auto = WhiteBalance._(0x00);
  static const WhiteBalance k3000 = WhiteBalance._(0x01);
  static const WhiteBalance k5500 = WhiteBalance._(0x02);
  static const WhiteBalance k6500 = WhiteBalance._(0x03);
  static const WhiteBalance camRaw = WhiteBalance._(0x04);

  static const List<WhiteBalance> all = [auto, k3000, k5500, k6500, camRaw];

  @override
  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (value) {
      case 0x00:
        return l10n.whiteBalanceAuto;
      case 0x01:
        return l10n.whiteBalance3000K;
      case 0x02:
        return l10n.whiteBalance5500K;
      case 0x03:
        return l10n.whiteBalance6500K;
      case 0x04:
        return l10n.whiteBalanceCamRaw;
      default:
        return toHex(value);
    }
  }

  static WhiteBalance fromByte(int byte) => enumFromByte(byte, all);
}
