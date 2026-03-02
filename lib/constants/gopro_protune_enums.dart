import 'package:flutter/material.dart';
import 'package:heroctrl/constants/gopro_endpoints.dart';
import 'package:heroctrl/constants/gopro_recording_enums.dart';
import 'package:heroctrl/l10n/app_localizations.dart';

class ProTune {
  final int _value;
  const ProTune._(this._value);

  int get value => _value;

  static const ProTune off = ProTune._(0x00);
  static const ProTune on = ProTune._(0x01);

  static const List<ProTune> all = [off, on];

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ProTune && _value == other._value;

  @override
  int get hashCode => _value.hashCode;

  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (_value) {
      case 0x00:
        return l10n.protuneOff;
      case 0x01:
        return l10n.protuneOn;
      default:
        return toHex(_value);
    }
  }
}

class WhiteBalance {
  final int _value;
  const WhiteBalance._(this._value);

  int get value => _value;

  static const WhiteBalance auto = WhiteBalance._(0x00);
  static const WhiteBalance k3000 = WhiteBalance._(0x01);
  static const WhiteBalance k5500 = WhiteBalance._(0x02);
  static const WhiteBalance k6500 = WhiteBalance._(0x03);
  static const WhiteBalance camRaw = WhiteBalance._(0x04);

  static const List<WhiteBalance> all = [auto, k3000, k5500, k6500, camRaw];

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is WhiteBalance && _value == other._value;

  @override
  int get hashCode => _value.hashCode;

  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (_value) {
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
        return toHex(_value);
    }
  }
}

class ExposureCompensation {
  final int _value;
  const ExposureCompensation._(this._value);

  int get value => _value;

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
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExposureCompensation && _value == other._value;

  @override
  int get hashCode => _value.hashCode;

  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (_value) {
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
        return toHex(_value);
    }
  }
}

class Sharpness {
  final int _value;
  const Sharpness._(this._value);

  int get value => _value;

  static const Sharpness high = Sharpness._(0x00);
  static const Sharpness medium = Sharpness._(0x01);
  static const Sharpness low = Sharpness._(0x02);

  static const List<Sharpness> all = [high, medium, low];

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Sharpness && _value == other._value;

  @override
  int get hashCode => _value.hashCode;

  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (_value) {
      case 0x00:
        return l10n.sharpnessHigh;
      case 0x01:
        return l10n.sharpnessMedium;
      case 0x02:
        return l10n.sharpnessLow;
      default:
        return toHex(_value);
    }
  }
}

class ISOLimit {
  final int _value;
  const ISOLimit._(this._value);

  int get value => _value;

  static const ISOLimit iso6400 = ISOLimit._(0x00);
  static const ISOLimit iso1600 = ISOLimit._(0x01);
  static const ISOLimit iso400 = ISOLimit._(0x02);

  static const List<ISOLimit> all = [iso6400, iso1600, iso400];

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ISOLimit && _value == other._value;

  @override
  int get hashCode => _value.hashCode;

  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (_value) {
      case 0x00:
        return l10n.isoLimit6400;
      case 0x01:
        return l10n.isoLimit1600;
      case 0x02:
        return l10n.isoLimit400;
      default:
        return toHex(_value);
    }
  }
}

class ColorProfile {
  final int _value;
  const ColorProfile._(this._value);

  int get value => _value;

  static const ColorProfile goPro = ColorProfile._(0x00);
  static const ColorProfile flat = ColorProfile._(0x01);

  static const List<ColorProfile> all = [goPro, flat];

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ColorProfile && _value == other._value;

  @override
  int get hashCode => _value.hashCode;

  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (_value) {
      case 0x00:
        return l10n.colorProfileGoPro;
      case 0x01:
        return l10n.colorProfileFlat;
      default:
        return toHex(_value);
    }
  }
}

class ProtuneVideoResolution {
  final int _value;
  const ProtuneVideoResolution._(this._value);

  int get value => _value;

  static const ProtuneVideoResolution res720p = ProtuneVideoResolution._(0x00);
  static const ProtuneVideoResolution res960p = ProtuneVideoResolution._(0x02);
  static const ProtuneVideoResolution res1080p = ProtuneVideoResolution._(0x03);
  static const ProtuneVideoResolution res1440p = ProtuneVideoResolution._(0x04);
  static const ProtuneVideoResolution res2_7k = ProtuneVideoResolution._(0x05);
  static const ProtuneVideoResolution res4k = ProtuneVideoResolution._(0x06);
  static const ProtuneVideoResolution res2_7k_17_9 = ProtuneVideoResolution._(
    0x07,
  );
  static const ProtuneVideoResolution res4k_17_9 = ProtuneVideoResolution._(
    0x08,
  );
  static const ProtuneVideoResolution res1080pSuperView =
      ProtuneVideoResolution._(0x09);
  static const ProtuneVideoResolution res720pSuperView =
      ProtuneVideoResolution._(0x0a);

  static const List<ProtuneVideoResolution> all = [
    res720p,
    res960p,
    res1080p,
    res1440p,
    res2_7k,
    res4k,
    res2_7k_17_9,
    res4k_17_9,
    res1080pSuperView,
    res720pSuperView,
  ];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProtuneVideoResolution && _value == other._value;

  @override
  int get hashCode => _value.hashCode;

  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (_value) {
      case 0x00:
        return l10n.resolution720p;
      case 0x02:
        return l10n.resolution960p;
      case 0x03:
        return l10n.resolution1080p;
      case 0x04:
        return l10n.resolution1440p;
      case 0x05:
        return l10n.resolution2_7k;
      case 0x06:
        return l10n.resolution4k;
      case 0x07:
        return l10n.resolution2_7k_17_9;
      case 0x08:
        return l10n.resolution4k_17_9;
      case 0x09:
        return l10n.resolution1080pSuperView;
      case 0x0a:
        return l10n.resolution720pSuperView;
      default:
        return toHex(_value);
    }
  }

  static final Map<ProtuneVideoResolution, List<FPS>>
  protuneVideoResolutionSupportedFPS = {
    res720p: [FPS.fps50, FPS.fps60, FPS.fps100, FPS.fps120],
    res960p: [FPS.fps50, FPS.fps60, FPS.fps100],
    res1080p: [
      FPS.fps24,
      FPS.fps25,
      FPS.fps30,
      FPS.fps48,
      FPS.fps50,
      FPS.fps60,
    ],
    res1440p: [FPS.fps24, FPS.fps25, FPS.fps30, FPS.fps48],
    res2_7k: [FPS.fps25, FPS.fps30],
    res4k: [FPS.fps12_5, FPS.fps15],
    res2_7k_17_9: [FPS.fps24],
    res4k_17_9: [FPS.fps12],
    res1080pSuperView: [FPS.fps24, FPS.fps25, FPS.fps30, FPS.fps48],
    res720pSuperView: [FPS.fps50, FPS.fps60, FPS.fps100],
  };
}
