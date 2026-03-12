import 'package:flutter/material.dart';
import 'package:heroctrl/gopro_settings/camera_setting.dart';
import 'package:heroctrl/gopro_settings/endpoints.dart';
import 'package:heroctrl/l10n/app_localizations.dart';

class LoopVideoDuration extends CameraSetting {
  const LoopVideoDuration._(super._value);

  static const LoopVideoDuration off = LoopVideoDuration._(0x00);
  static const LoopVideoDuration fiveMinutes = LoopVideoDuration._(0x01);
  static const LoopVideoDuration twentyMinutes = LoopVideoDuration._(0x02);
  static const LoopVideoDuration oneHour = LoopVideoDuration._(0x03);
  static const LoopVideoDuration twoHours = LoopVideoDuration._(0x04);
  static const LoopVideoDuration maxStorage = LoopVideoDuration._(0x05);

  static const List<LoopVideoDuration> all = [
    off,
    fiveMinutes,
    twentyMinutes,
    oneHour,
    twoHours,
    maxStorage,
  ];

  @override
  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (value) {
      case 0x00:
        return l10n.volumeOff;
      case 0x01:
        return l10n.loopVideo5Min;
      case 0x02:
        return l10n.loopVideo20Min;
      case 0x03:
        return l10n.loopVideo1Hour;
      case 0x04:
        return l10n.loopVideo2Hour;
      case 0x05:
        return l10n.loopVideoMaxStorage;
      default:
        return toHex(value);
    }
  }

  static LoopVideoDuration fromByte(int byte) => enumFromByte(byte, all);
}
