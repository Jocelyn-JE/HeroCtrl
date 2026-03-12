import 'package:flutter/material.dart';
import 'package:heroctrl/gopro_settings/camera_setting.dart';
import 'package:heroctrl/gopro_settings/endpoints.dart';
import 'package:heroctrl/l10n/app_localizations.dart';

class TimelapseInterval extends CameraSetting {
  const TimelapseInterval._(super.value);

  static const TimelapseInterval halfASecond = TimelapseInterval._(0x00);
  static const TimelapseInterval oneSecond = TimelapseInterval._(0x01);
  static const TimelapseInterval twoSeconds = TimelapseInterval._(0x02);
  static const TimelapseInterval fiveSeconds = TimelapseInterval._(0x05);
  static const TimelapseInterval tenSeconds = TimelapseInterval._(0x0a);
  static const TimelapseInterval thirtySeconds = TimelapseInterval._(0x1e);
  static const TimelapseInterval sixtySeconds = TimelapseInterval._(0x3c);

  static const List<TimelapseInterval> all = [
    halfASecond,
    oneSecond,
    twoSeconds,
    fiveSeconds,
    tenSeconds,
    thirtySeconds,
    sixtySeconds,
  ];

  @override
  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (value) {
      case 0x00:
        return l10n.timelapse0_5Sec;
      case 0x01:
        return l10n.timelapse1Sec;
      case 0x02:
        return l10n.timelapse2Sec;
      case 0x05:
        return l10n.timelapse5Sec;
      case 0x0a:
        return l10n.timelapse10Sec;
      case 0x1e:
        return l10n.timelapse30Sec;
      case 0x3c:
        return l10n.timelapse60Sec;
      default:
        return toHex(value);
    }
  }

  static TimelapseInterval fromByte(int byte) => enumFromByte(byte, all);
}
