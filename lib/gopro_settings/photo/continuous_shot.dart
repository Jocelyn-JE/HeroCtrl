import 'package:flutter/material.dart';
import 'package:heroctrl/gopro_settings/camera_setting.dart';
import 'package:heroctrl/gopro_settings/endpoints.dart';
import 'package:heroctrl/l10n/app_localizations.dart';

class ContinuousShot extends CameraSetting {
  const ContinuousShot._(super.value);

  static const ContinuousShot off = ContinuousShot._(0x00);
  static const ContinuousShot threePhotos = ContinuousShot._(0x03);
  static const ContinuousShot fivePhotos = ContinuousShot._(0x05);
  static const ContinuousShot tenPhotos = ContinuousShot._(0x0a);

  static const List<ContinuousShot> all = [
    off,
    threePhotos,
    fivePhotos,
    tenPhotos,
  ];

  @override
  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (value) {
      case 0x00:
        return l10n.volumeOff;
      case 0x03:
        return l10n.continuousShot3Photos;
      case 0x05:
        return l10n.continuousShot5Photos;
      case 0x0a:
        return l10n.continuousShot10Photos;
      default:
        return toHex(value);
    }
  }

  static ContinuousShot fromByte(int byte) => enumFromByte(byte, all);
}
