import 'package:flutter/material.dart';
import 'package:heroctrl/gopro_settings/camera_setting.dart';
import 'package:heroctrl/gopro_settings/endpoints.dart';
import 'package:heroctrl/l10n/app_localizations.dart';

class Fps extends CameraSetting {
  const Fps._(super._value);

  static const Fps fps12 = Fps._(0x00);
  static const Fps fps12_5 = Fps._(0x0b);
  static const Fps fps15 = Fps._(0x01);
  static const Fps fps24 = Fps._(0x02);
  static const Fps fps25 = Fps._(0x03);
  static const Fps fps30 = Fps._(0x04);
  static const Fps fps48 = Fps._(0x05);
  static const Fps fps50 = Fps._(0x06);
  static const Fps fps60 = Fps._(0x07);
  static const Fps fps100 = Fps._(0x08);
  static const Fps fps120 = Fps._(0x09);
  static const Fps fps240 = Fps._(0x0a);

  static const List<Fps> all = [
    fps12,
    fps12_5,
    fps15,
    fps24,
    fps25,
    fps30,
    fps48,
    fps50,
    fps60,
    fps100,
    fps120,
    fps240,
  ];

  @override
  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (value) {
      case 0x00:
        return l10n.fps12;
      case 0x0b:
        return l10n.fps12_5;
      case 0x01:
        return l10n.fps15;
      case 0x02:
        return l10n.fps24;
      case 0x03:
        return l10n.fps25;
      case 0x04:
        return l10n.fps30;
      case 0x05:
        return l10n.fps48;
      case 0x06:
        return l10n.fps50;
      case 0x07:
        return l10n.fps60;
      case 0x08:
        return l10n.fps100;
      case 0x09:
        return l10n.fps120;
      case 0x0a:
        return l10n.fps240;
      default:
        return '${toHex(value)}fps';
    }
  }

  static Fps fromByte(int byte) => enumFromByte(byte, all);
}
