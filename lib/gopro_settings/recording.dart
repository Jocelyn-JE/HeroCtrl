import 'package:flutter/material.dart';
import 'package:heroctrl/gopro_settings/camera_setting.dart';
import 'package:heroctrl/gopro_settings/endpoints.dart';
import 'package:heroctrl/gopro_settings/system.dart';
import 'package:heroctrl/l10n/app_localizations.dart';

class VideoResolution extends CameraSetting {
  final Icon _icon;
  final double _aspectRatio;

  const VideoResolution._(super._value, this._icon, this._aspectRatio);

  Icon get icon => _icon;
  double get aspectRatio => _aspectRatio;

  // Define all valid instances
  // TODO: Find better icons for each resolution
  static const VideoResolution wvga240fps = VideoResolution._(
    0x00,
    Icon(Icons.hd_outlined),
    16 / 9,
  );
  static const VideoResolution res720p = VideoResolution._(
    0x01,
    Icon(Icons.hd),
    16 / 9,
  );
  static const VideoResolution res960p = VideoResolution._(
    0x02,
    Icon(Icons.hd_outlined),
    4 / 3,
  );
  static const VideoResolution res1080p = VideoResolution._(
    0x03,
    Icon(Icons.high_quality),
    16 / 9,
  );
  static const VideoResolution res1440p = VideoResolution._(
    0x04,
    Icon(Icons.two_k_outlined),
    4 / 3,
  );
  static const VideoResolution res2_7k = VideoResolution._(
    0x05,
    Icon(Icons.two_k_plus),
    16 / 9,
  );
  static const VideoResolution res4k = VideoResolution._(
    0x06,
    Icon(Icons.four_k),
    16 / 9,
  );
  static const VideoResolution res2_7k_17_9 = VideoResolution._(
    0x07,
    Icon(Icons.two_k_plus_outlined),
    16 / 9,
  );
  static const VideoResolution res4k_17_9 = VideoResolution._(
    0x08,
    Icon(Icons.four_k_outlined),
    16 / 9,
  );
  static const VideoResolution res1080pSuperView = VideoResolution._(
    0x09,
    Icon(Icons.width_wide),
    16 / 9,
  );
  static const VideoResolution res720pSuperView = VideoResolution._(
    0x0a,
    Icon(Icons.width_normal),
    16 / 9,
  );

  static const List<VideoResolution> all = [
    wvga240fps,
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
  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (value) {
      case 0x00:
        return l10n.resolutionWvga240fps;
      case 0x01:
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

  static final Map<VideoResolution, List<Fps>> supportedFps = {
    wvga240fps: [Fps.fps240],
    // Note: 720p in NTSC only supports 60fps and 120fps, while in PAL it supports 50fps and 100fps
    res720p: [Fps.fps50, Fps.fps60, Fps.fps100, Fps.fps120],
    res960p: [Fps.fps48, Fps.fps50, Fps.fps60, Fps.fps100],
    res1080p: [
      Fps.fps24,
      Fps.fps25,
      Fps.fps30,
      Fps.fps48,
      Fps.fps50,
      Fps.fps60,
    ],
    res1440p: [Fps.fps24, Fps.fps25, Fps.fps30, Fps.fps48],
    res2_7k: [Fps.fps25, Fps.fps30],
    res4k: [Fps.fps12_5, Fps.fps15],
    res2_7k_17_9: [Fps.fps24],
    res4k_17_9: [Fps.fps12],
    res1080pSuperView: [
      Fps.fps24,
      Fps.fps25,
      Fps.fps30,
      Fps.fps48,
      Fps.fps50,
      Fps.fps60,
    ],
    res720pSuperView: [Fps.fps48, Fps.fps50, Fps.fps60, Fps.fps100],
  };

  /// Get the valid FPS options for the current resolution and video mode.
  /// This is the intersection of:
  /// - FPS supported by the current resolution
  /// - FPS supported by the current video mode (NTSC/PAL)
  static List<Fps> getSupportedFps(
    VideoResolution resolution,
    VideoStandard standard,
  ) {
    List<Fps> fpsForResolution;
    List<Fps> fpsForStandard;

    if (resolution == res720p) {
      return standard == VideoStandard.ntsc
          ? [Fps.fps60, Fps.fps120]
          : [Fps.fps50, Fps.fps100];
    }
    fpsForResolution = supportedFps[resolution] ?? [];
    fpsForStandard = VideoStandard.videoStandardFrameRates[standard] ?? [];
    return fpsForResolution
        .where((fps) => fpsForStandard.contains(fps))
        .toList();
  }

  static final Map<VideoResolution, List<Fov>> supportedFov = {
    wvga240fps: [Fov.wide],
    res720p: [Fov.wide, Fov.medium, Fov.narrow],
    // Note: 720p at 100fps and 120fps only support Wide and Narrow (no Medium)
    res960p: [Fov.wide],
    res1080p: [Fov.wide, Fov.medium, Fov.narrow],
    res1440p: [Fov.wide],
    res2_7k: [Fov.wide, Fov.medium],
    res4k: [Fov.wide],
    res2_7k_17_9: [Fov.wide, Fov.medium],
    res4k_17_9: [Fov.wide],
    res1080pSuperView: [Fov.wide],
    res720pSuperView: [Fov.wide],
  };

  /// Returns supported FOV for a given resolution and FPS combination
  /// Special case: 720p at 100/120fps only supports Wide and Narrow
  static List<Fov> getSupportedFov(VideoResolution resolution, Fps fps) {
    if (resolution == res720p && (fps == Fps.fps100 || fps == Fps.fps120)) {
      return [Fov.wide, Fov.narrow];
    }
    return supportedFov[resolution] ?? [Fov.wide];
  }

  static VideoResolution fromByte(int byte) => enumFromByte(byte, all);
}

class Fov extends CameraSetting {
  final double _factor;

  const Fov._(super._value, this._factor);

  double get factor => _factor;

  static const Fov wide = Fov._(0x00, 1.0);
  static const Fov medium = Fov._(0x01, 1.42);
  static const Fov narrow = Fov._(0x02, 2.0);

  static const List<Fov> all = [wide, medium, narrow];

  @override
  String getLocalizedName(BuildContext context) {
    final String factorStr = factor == factor.toInt()
        ? '${factor.toInt()}x'
        : '${factor.toStringAsFixed(2)}x';

    return factorStr;
  }

  static Fov fromByte(int byte) => enumFromByte(byte, all);
}

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

class VideoAndPhotoInterval extends CameraSetting {
  const VideoAndPhotoInterval._(super._value);

  static const VideoAndPhotoInterval off = VideoAndPhotoInterval._(0x00);
  static const VideoAndPhotoInterval every5s = VideoAndPhotoInterval._(0x01);
  static const VideoAndPhotoInterval every10s = VideoAndPhotoInterval._(0x02);
  static const VideoAndPhotoInterval every30s = VideoAndPhotoInterval._(0x03);
  static const VideoAndPhotoInterval every60s = VideoAndPhotoInterval._(0x04);

  static const List<VideoAndPhotoInterval> all = [
    off,
    every5s,
    every10s,
    every30s,
    every60s,
  ];

  @override
  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (value) {
      case 0x00:
        return l10n.volumeOff;
      case 0x01:
        return l10n.videoAndPhotoEvery5s;
      case 0x02:
        return l10n.videoAndPhotoEvery10s;
      case 0x03:
        return l10n.videoAndPhotoEvery30s;
      case 0x04:
        return l10n.videoAndPhotoEvery60s;
      default:
        return toHex(value);
    }
  }

  static VideoAndPhotoInterval fromByte(int byte) => enumFromByte(byte, all);
}

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

class LowLight extends CameraSetting {
  const LowLight._(super._value);

  static const LowLight off = LowLight._(0x00);
  static const LowLight on = LowLight._(0x01);

  static const List<LowLight> all = [off, on];

  @override
  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (value) {
      case 0x00:
        return l10n.lowLightOff;
      case 0x01:
        return l10n.lowLightOn;
      default:
        return toHex(value);
    }
  }

  static LowLight fromByte(int byte) => enumFromByte(byte, all);
}

class SpotMeter extends CameraSetting {
  const SpotMeter._(super._value);

  static const SpotMeter off = SpotMeter._(0x00);
  static const SpotMeter on = SpotMeter._(0x01);

  static const List<SpotMeter> all = [off, on];

  @override
  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (value) {
      case 0x00:
        return l10n.spotMeterOff;
      case 0x01:
        return l10n.spotMeterOn;
      default:
        return toHex(value);
    }
  }

  static SpotMeter fromByte(int byte) => enumFromByte(byte, all);
}
