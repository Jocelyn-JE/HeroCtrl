import 'package:flutter/material.dart';
import 'package:heroctrl/gopro_settings/camera_setting.dart';
import 'package:heroctrl/gopro_settings/endpoints.dart';
import 'package:heroctrl/l10n/app_localizations.dart';

class WhiteBalance extends CameraSetting {
  const WhiteBalance._(super.value, this._icon);
  final Icon _icon;

  static const WhiteBalance auto = WhiteBalance._(0x00, Icon(Icons.wb_auto));
  static const WhiteBalance k3000 = WhiteBalance._(
    0x01,
    Icon(Icons.wb_incandescent),
  );
  static const WhiteBalance k5500 = WhiteBalance._(0x02, Icon(Icons.wb_sunny));
  static const WhiteBalance k6500 = WhiteBalance._(0x03, Icon(Icons.wb_cloudy));
  static const WhiteBalance camRaw = WhiteBalance._(0x04, Icon(Icons.raw_on));

  static const List<WhiteBalance> all = [auto, k3000, k5500, k6500, camRaw];

  Icon get icon => _icon;

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
