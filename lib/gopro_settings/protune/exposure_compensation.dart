import 'package:flutter/material.dart';
import 'package:heroctrl/gopro_settings/camera_setting.dart';
import 'package:heroctrl/gopro_settings/endpoints.dart';
import 'package:heroctrl/l10n/app_localizations.dart';

class ExposureCompensation extends CameraSetting {
  const ExposureCompensation._(super.value);

  static const ExposureCompensation minusTwo = ExposureCompensation._(0x06);
  static const ExposureCompensation minusOneAndHalf = ExposureCompensation._(
    0x07,
  );
  static const ExposureCompensation minusOne = ExposureCompensation._(0x08);
  static const ExposureCompensation minusHalf = ExposureCompensation._(0x09);
  static const ExposureCompensation zero = ExposureCompensation._(0x0a);
  static const ExposureCompensation plusHalf = ExposureCompensation._(0x0b);
  static const ExposureCompensation plusOne = ExposureCompensation._(0x0c);
  static const ExposureCompensation plusOneAndHalf = ExposureCompensation._(
    0x0d,
  );
  static const ExposureCompensation plusTwo = ExposureCompensation._(0x0e);

  static const List<ExposureCompensation> all = [
    minusTwo,
    minusOneAndHalf,
    minusOne,
    minusHalf,
    zero,
    plusHalf,
    plusOne,
    plusOneAndHalf,
    plusTwo,
  ];

  @override
  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (value) {
      case 0x06:
        return l10n.exposureCompensation2Minus;
      case 0x07:
        return l10n.exposureCompensation1_5Minus;
      case 0x08:
        return l10n.exposureCompensation1Minus;
      case 0x09:
        return l10n.exposureCompensation0_5Minus;
      case 0x0a:
        return l10n.exposureCompensation0;
      case 0x0b:
        return l10n.exposureCompensation0_5Plus;
      case 0x0c:
        return l10n.exposureCompensation1Plus;
      case 0x0d:
        return l10n.exposureCompensation1_5Plus;
      case 0x0e:
        return l10n.exposureCompensation2Plus;
      default:
        return toHex(value);
    }
  }

  static ExposureCompensation fromByte(int byte) => enumFromByte(byte, all);
}
