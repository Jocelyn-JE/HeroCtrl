import 'package:flutter/material.dart';
import 'package:heroctrl/constants/enum_class.dart';
import 'package:heroctrl/constants/gopro_endpoints.dart';
import 'package:heroctrl/constants/gopro_recording_enums.dart';
import 'package:heroctrl/constants/gopro_system_enums.dart';
import 'package:heroctrl/l10n/app_localizations.dart';

class ProTune extends EnumClass {
  const ProTune._(super.value);

  static const ProTune off = ProTune._(0x00);
  static const ProTune on = ProTune._(0x01);

  static const List<ProTune> all = [off, on];

  @override
  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (value) {
      case 0x00:
        return l10n.protuneOff;
      case 0x01:
        return l10n.protuneOn;
      default:
        return toHex(value);
    }
  }

  static ProTune fromByte(int byte) => enumFromByte(byte, all);
}

class WhiteBalance extends EnumClass {
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

class ExposureCompensation extends EnumClass {
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

class Sharpness extends EnumClass {
  const Sharpness._(super.value);

  static const Sharpness high = Sharpness._(0x00);
  static const Sharpness medium = Sharpness._(0x01);
  static const Sharpness low = Sharpness._(0x02);

  static const List<Sharpness> all = [high, medium, low];

  @override
  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (value) {
      case 0x00:
        return l10n.sharpnessHigh;
      case 0x01:
        return l10n.sharpnessMedium;
      case 0x02:
        return l10n.sharpnessLow;
      default:
        return toHex(value);
    }
  }

  static Sharpness fromByte(int byte) => enumFromByte(byte, all);
}

class IsoLimit extends EnumClass {
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

class ColorProfile extends EnumClass {
  const ColorProfile._(super.value);

  static const ColorProfile goPro = ColorProfile._(0x00);
  static const ColorProfile flat = ColorProfile._(0x01);

  static const List<ColorProfile> all = [goPro, flat];

  @override
  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (value) {
      case 0x00:
        return l10n.colorProfileGoPro;
      case 0x01:
        return l10n.colorProfileFlat;
      default:
        return toHex(value);
    }
  }

  static ColorProfile fromByte(int byte) => enumFromByte(byte, all);
}

class ProTuneVideoResolution extends EnumClass {
  const ProTuneVideoResolution._(super.value);

  static const ProTuneVideoResolution res720p = ProTuneVideoResolution._(0x00);
  static const ProTuneVideoResolution res960p = ProTuneVideoResolution._(0x02);
  static const ProTuneVideoResolution res1080p = ProTuneVideoResolution._(0x03);
  static const ProTuneVideoResolution res1440p = ProTuneVideoResolution._(0x04);
  static const ProTuneVideoResolution res2_7k = ProTuneVideoResolution._(0x05);
  static const ProTuneVideoResolution res4k = ProTuneVideoResolution._(0x06);
  static const ProTuneVideoResolution res2_7k_17_9 = ProTuneVideoResolution._(
    0x07,
  );
  static const ProTuneVideoResolution res4k_17_9 = ProTuneVideoResolution._(
    0x08,
  );
  static const ProTuneVideoResolution res1080pSuperView =
      ProTuneVideoResolution._(0x09);
  static const ProTuneVideoResolution res720pSuperView =
      ProTuneVideoResolution._(0x0a);

  static const List<ProTuneVideoResolution> all = [
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

  // ProTune-capable video resolutions in the regular camera resolution domain.
  static const List<VideoResolution> supportedVideoResolutions = [
    VideoResolution.res720p,
    VideoResolution.res960p,
    VideoResolution.res1080p,
    VideoResolution.res1440p,
    VideoResolution.res2_7k,
    VideoResolution.res4k,
    VideoResolution.res2_7k_17_9,
    VideoResolution.res4k_17_9,
    VideoResolution.res1080pSuperView,
    VideoResolution.res720pSuperView,
  ];

  static ProTuneVideoResolution? fromVideoResolution(
    VideoResolution resolution,
  ) {
    if (resolution == VideoResolution.res720p) return res720p;
    if (resolution == VideoResolution.res960p) return res960p;
    if (resolution == VideoResolution.res1080p) return res1080p;
    if (resolution == VideoResolution.res1440p) return res1440p;
    if (resolution == VideoResolution.res2_7k) return res2_7k;
    if (resolution == VideoResolution.res4k) return res4k;
    if (resolution == VideoResolution.res2_7k_17_9) return res2_7k_17_9;
    if (resolution == VideoResolution.res4k_17_9) return res4k_17_9;
    if (resolution == VideoResolution.res1080pSuperView) {
      return res1080pSuperView;
    }
    if (resolution == VideoResolution.res720pSuperView) return res720pSuperView;
    return null;
  }

  @override
  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (value) {
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
        return toHex(value);
    }
  }

  static final Map<ProTuneVideoResolution, List<Fps>>
  proTuneVideoResolutionSupportedFps = {
    res720p: [Fps.fps120, Fps.fps100, Fps.fps60, Fps.fps50],
    res960p: [Fps.fps100, Fps.fps60, Fps.fps50],
    res1080p: [
      Fps.fps60,
      Fps.fps50,
      Fps.fps48,
      Fps.fps30,
      Fps.fps25,
      Fps.fps24,
    ],
    res1440p: [Fps.fps48, Fps.fps30, Fps.fps25, Fps.fps24],
    res2_7k: [Fps.fps30, Fps.fps25],
    res4k: [Fps.fps15, Fps.fps12_5],
    res2_7k_17_9: [Fps.fps24],
    res4k_17_9: [Fps.fps12],
    res1080pSuperView: [
      Fps.fps60,
      Fps.fps50,
      Fps.fps48,
      Fps.fps30,
      Fps.fps25,
      Fps.fps24,
    ],
    res720pSuperView: [Fps.fps100, Fps.fps60, Fps.fps50],
  };

  static List<Fps> getSupportedFps(
    ProTuneVideoResolution? resolution,
    VideoStandard standard,
  ) {
    List<Fps> fpsForResolution;
    List<Fps> fpsForStandard;

    if (resolution == null) return [];
    if (resolution == res720p) {
      return standard == VideoStandard.ntsc
          ? [Fps.fps60, Fps.fps120]
          : [Fps.fps50, Fps.fps100];
    }
    fpsForResolution = proTuneVideoResolutionSupportedFps[resolution] ?? [];
    fpsForStandard = VideoStandard.videoStandardFrameRates[standard] ?? [];
    return fpsForResolution
        .where((fps) => fpsForStandard.contains(fps))
        .toList();
  }

  static ProTuneVideoResolution fromByte(int byte) => enumFromByte(byte, all);
}
