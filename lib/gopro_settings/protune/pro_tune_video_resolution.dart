import 'package:flutter/material.dart';
import 'package:heroctrl/gopro_settings/camera_setting.dart';
import 'package:heroctrl/gopro_settings/endpoints.dart';
import 'package:heroctrl/gopro_settings/recording/fps.dart';
import 'package:heroctrl/gopro_settings/recording/video_resolution.dart';
import 'package:heroctrl/gopro_settings/system/video_standard.dart';
import 'package:heroctrl/l10n/app_localizations.dart';

class ProTuneVideoResolution extends CameraSetting {
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
