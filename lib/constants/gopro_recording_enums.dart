import 'package:flutter/material.dart';
import 'package:heroctrl/constants/gopro_endpoints.dart';
import 'package:heroctrl/l10n/app_localizations.dart';

class VideoResolution {
  final int _value;
  final Icon _icon;
  final double _aspectRatio;

  const VideoResolution._(this._value, this._icon, this._aspectRatio);

  int get value => _value;
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
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VideoResolution && _value == other._value;

  @override
  int get hashCode => _value.hashCode;

  /// Returns the localized display name for this resolution
  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (_value) {
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
        return toHex(_value);
    }
  }

  static final Map<VideoResolution, List<FPS>> supportedFPS = {
    wvga240fps: [FPS.fps240],
    res720p: [FPS.fps50, FPS.fps60, FPS.fps100, FPS.fps120],
    res960p: [FPS.fps48, FPS.fps50, FPS.fps60, FPS.fps100],
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
    res1080pSuperView: [
      FPS.fps24,
      FPS.fps25,
      FPS.fps30,
      FPS.fps48,
      FPS.fps50,
      FPS.fps60,
    ],
    res720pSuperView: [FPS.fps48, FPS.fps50, FPS.fps60, FPS.fps100],
  };
}

class FOV {
  final int _value;
  final double _factor;

  const FOV._(this._value, this._factor);

  int get value => _value;
  double get factor => _factor;

  static const FOV wide = FOV._(0x00, 1.0);
  static const FOV medium = FOV._(0x01, 1.42);
  static const FOV narrow = FOV._(0x02, 2.0);

  static const List<FOV> all = [wide, medium, narrow];

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is FOV && _value == other._value;

  @override
  int get hashCode => _value.hashCode;

  String getLocalizedName(BuildContext context) {
    final factorStr = factor == factor.toInt()
        ? '${factor.toInt()}x'
        : '${factor.toStringAsFixed(2)}x';

    return factorStr;
  }
}

class FPS {
  final int _value;
  const FPS._(this._value);

  int get value => _value;

  static const FPS fps12 = FPS._(0x00);
  static const FPS fps12_5 = FPS._(0x0b);
  static const FPS fps15 = FPS._(0x01);
  static const FPS fps24 = FPS._(0x02);
  static const FPS fps25 = FPS._(0x03);
  static const FPS fps30 = FPS._(0x04);
  static const FPS fps48 = FPS._(0x05);
  static const FPS fps50 = FPS._(0x06);
  static const FPS fps60 = FPS._(0x07);
  static const FPS fps100 = FPS._(0x08);
  static const FPS fps120 = FPS._(0x09);
  static const FPS fps240 = FPS._(0x0a);

  static const List<FPS> all = [
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
  bool operator ==(Object other) =>
      identical(this, other) || other is FPS && _value == other._value;

  @override
  int get hashCode => _value.hashCode;

  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (_value) {
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
        return '${toHex(_value)}fps';
    }
  }
}

class VideoAndPhotoInterval {
  final int _value;
  const VideoAndPhotoInterval._(this._value);

  int get value => _value;

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
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VideoAndPhotoInterval && _value == other._value;

  @override
  int get hashCode => _value.hashCode;

  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (_value) {
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
        return toHex(_value);
    }
  }
}

class LoopVideoDuration {
  final int _value;
  const LoopVideoDuration._(this._value);

  int get value => _value;

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
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoopVideoDuration && _value == other._value;

  @override
  int get hashCode => _value.hashCode;

  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (_value) {
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
        return toHex(_value);
    }
  }
}

class LowLight {
  final int _value;
  const LowLight._(this._value);

  int get value => _value;

  static const LowLight off = LowLight._(0x00);
  static const LowLight on = LowLight._(0x01);

  static const List<LowLight> all = [off, on];

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is LowLight && _value == other._value;

  @override
  int get hashCode => _value.hashCode;

  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (_value) {
      case 0x00:
        return l10n.lowLightOff;
      case 0x01:
        return l10n.lowLightOn;
      default:
        return toHex(_value);
    }
  }
}

class SpotMeter {
  final int _value;
  const SpotMeter._(this._value);

  int get value => _value;

  static const SpotMeter off = SpotMeter._(0x00);
  static const SpotMeter on = SpotMeter._(0x01);

  static const List<SpotMeter> all = [off, on];

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is SpotMeter && _value == other._value;

  @override
  int get hashCode => _value.hashCode;

  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (_value) {
      case 0x00:
        return l10n.spotMeterOff;
      case 0x01:
        return l10n.spotMeterOn;
      default:
        return toHex(_value);
    }
  }
}
