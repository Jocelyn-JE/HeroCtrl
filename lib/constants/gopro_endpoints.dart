import 'package:flutter/material.dart';
import 'package:heroctrl/l10n/app_localizations.dart';

/// Converts an integer to a 2-digit hexadecimal string (e.g., 5 -> '05', 10 -> '0a')
String toHex(int value) => value.toRadixString(16).padLeft(2, '0');

class GoProEndpoints {
  static const String baseUrl = 'http://10.5.5.9:80';
  static const String livestreamUrl = 'http://10.5.5.9:8080/live/amba.m3u8';
  // Actions
  static const String power = 'pw';
  static const String shutter = 'sh';
  static const String videoPreview = 'pv';
  static const String locate = 'll';
  static const String cameraMode = 'cm';
  // Recording settings
  static const String videoResolution = 'vv';
  static const String fov = 'fv';
  static const String fps = 'fs';
  static const String simultaneousVideoAndPhoto = 'pn';
  static const String loopVideo = 'lo';
  static const String lowLight = 'lw';
  static const String spotMeter = 'ex';
  // Photo settings
  static const String photoResolution = 'pr';
  static const String timeLapseInterval = 'ti';
  static const String continuousShot = 'cs';
  static const String burstRate = 'bu';
  // ProTune settings
  static const String protune = 'pt';
  static const String whiteBalance = 'wb';
  static const String exposureCompensation = 'ev';
  static const String sharpness = 'sp';
  static const String iso = 'ga';
  static const String color = 'co';
  static const String protuneResolution = 'vv';
  // System settings
  static const String volume = 'bs';
  static const String leds = 'lb';
  static const String defaultCameraMode = 'dm';
  static const String timeAndDate = 'tm';
  static const String videoMode = 'vm';
  static const String orientation = 'up';
  static const String oneButtonMode = 'ob';
  static const String autoPowerOff = 'ao';
  // Info endpoints
  static const String status = 'sx';
  static const String batteryLevel = 'bl';
  static const String cameraModel = 'cn';
  static const String cameraPassword = 'sd';
  static const String bacpacBatteryLevel = 'bl';
  static const String wifiInfo = 'wp';
  static const String ports = 'pf';
  static const String serialNumber = 'sn';
  static const String bacpacVersion = 'cv';
  static const String cameraVersion = 'cv';
  // Media management
  static const String deleteLastMedia = 'dl';
  static const String deleteAllMedia = 'da';
  static const String deleteFile = 'df';
  static const String formatSDCard = 'fo';
}

class Power {
  final int _value;
  const Power._(this._value);

  int get value => _value;

  static const Power off = Power._(0x00);
  static const Power on = Power._(0x01);

  static const List<Power> all = [off, on];

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Power && _value == other._value;

  @override
  int get hashCode => _value.hashCode;

  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (_value) {
      case 0x00:
        return l10n.volumeOff;
      case 0x01:
        return l10n.buttonOn;
      default:
        return toHex(_value);
    }
  }
}

class Shutter {
  final int _value;
  const Shutter._(this._value);

  int get value => _value;

  static const Shutter stop = Shutter._(0x00);
  static const Shutter start = Shutter._(0x01);

  static const List<Shutter> all = [stop, start];

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Shutter && _value == other._value;

  @override
  int get hashCode => _value.hashCode;

  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (_value) {
      case 0x00:
        return l10n.volumeOff;
      case 0x01:
        return l10n.buttonOn;
      default:
        return toHex(_value);
    }
  }
}

class VideoPreview {
  final int _value;
  const VideoPreview._(this._value);

  int get value => _value;

  static const VideoPreview off = VideoPreview._(0x00);
  static const VideoPreview on = VideoPreview._(0x02);

  static const List<VideoPreview> all = [off, on];

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is VideoPreview && _value == other._value;

  @override
  int get hashCode => _value.hashCode;

  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (_value) {
      case 0x00:
        return l10n.volumeOff;
      case 0x02:
        return l10n.buttonOn;
      default:
        return toHex(_value);
    }
  }
}

class Locate {
  final int _value;
  const Locate._(this._value);

  int get value => _value;

  static const Locate off = Locate._(0x00);
  static const Locate on = Locate._(0x01);

  static const List<Locate> all = [off, on];

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Locate && _value == other._value;

  @override
  int get hashCode => _value.hashCode;

  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (_value) {
      case 0x00:
        return l10n.volumeOff;
      case 0x01:
        return l10n.buttonOn;
      default:
        return toHex(_value);
    }
  }
}

class CameraMode {
  final int _value;
  const CameraMode._(this._value);

  int get value => _value;

  static const CameraMode videoMode = CameraMode._(0x00);
  static const CameraMode photoMode = CameraMode._(0x01);
  static const CameraMode burstMode = CameraMode._(0x02);
  static const CameraMode timerMode = CameraMode._(0x04);
  static const CameraMode hdmiMode = CameraMode._(0x05);

  static const List<CameraMode> all = [
    videoMode,
    photoMode,
    burstMode,
    timerMode,
    hdmiMode,
  ];

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is CameraMode && _value == other._value;

  @override
  int get hashCode => _value.hashCode;

  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (_value) {
      case 0x00:
        return l10n.defaultModeVideo;
      case 0x01:
        return l10n.defaultModePhoto;
      case 0x02:
        return l10n.defaultModeBurst;
      case 0x04:
        return l10n.cameraModeTimer;
      case 0x05:
        return l10n.cameraModeHdmi;
      default:
        return toHex(_value);
    }
  }
}

class VideoResolution {
  final int _value;

  const VideoResolution._(this._value);

  int get value => _value;

  // Define all valid instances
  static const VideoResolution wvga240fps = VideoResolution._(0x00);
  static const VideoResolution res720p = VideoResolution._(0x01);
  static const VideoResolution res960p = VideoResolution._(0x02);
  static const VideoResolution res1080p = VideoResolution._(0x03);
  static const VideoResolution res1440p = VideoResolution._(0x04);
  static const VideoResolution res2_7k = VideoResolution._(0x05);
  static const VideoResolution res4k = VideoResolution._(0x06);
  static const VideoResolution res2_7k_17_9 = VideoResolution._(0x07);
  static const VideoResolution res4k_17_9 = VideoResolution._(0x08);
  static const VideoResolution res1080pSuperView = VideoResolution._(0x09);
  static const VideoResolution res720pSuperView = VideoResolution._(0x0a);

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
    res720p: [FPS.fps50, FPS.fps60, FPS.fps120],
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
  const FOV._(this._value);

  int get value => _value;

  static const FOV wide = FOV._(0x00);
  static const FOV medium = FOV._(0x01);
  static const FOV narrow = FOV._(0x02);

  static const List<FOV> all = [wide, medium, narrow];

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is FOV && _value == other._value;

  @override
  int get hashCode => _value.hashCode;

  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (_value) {
      case 0x00:
        return l10n.fovWide;
      case 0x01:
        return l10n.fovMedium;
      case 0x02:
        return l10n.fovNarrow;
      default:
        return toHex(_value);
    }
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

class PhotoResolution {
  final int _value;
  const PhotoResolution._(this._value);

  int get value => _value;

  static const PhotoResolution res5MPmedium = PhotoResolution._(0x03);
  static const PhotoResolution res7MPwide = PhotoResolution._(0x04);
  static const PhotoResolution res12MPwide = PhotoResolution._(0x05);
  static const PhotoResolution res7MPmedium = PhotoResolution._(0x06);

  static const List<PhotoResolution> all = [
    res5MPmedium,
    res7MPwide,
    res12MPwide,
    res7MPmedium,
  ];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PhotoResolution && _value == other._value;

  @override
  int get hashCode => _value.hashCode;

  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (_value) {
      case 0x03:
        return l10n.photoResolution5MpMedium;
      case 0x04:
        return l10n.photoResolution7MpWide;
      case 0x05:
        return l10n.photoResolution12MpWide;
      case 0x06:
        return l10n.photoResolution7MpMedium;
      default:
        return toHex(_value);
    }
  }
}

class TimelapseInterval {
  final int _value;
  const TimelapseInterval._(this._value);

  int get value => _value;

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
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimelapseInterval && _value == other._value;

  @override
  int get hashCode => _value.hashCode;

  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (_value) {
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
        return toHex(_value);
    }
  }
}

class ContinuousShot {
  final int _value;
  const ContinuousShot._(this._value);

  int get value => _value;

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
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContinuousShot && _value == other._value;

  @override
  int get hashCode => _value.hashCode;

  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (_value) {
      case 0x00:
        return l10n.volumeOff;
      case 0x03:
        return l10n.continuousShot3Photos;
      case 0x05:
        return l10n.continuousShot5Photos;
      case 0x0a:
        return l10n.continuousShot10Photos;
      default:
        return toHex(_value);
    }
  }
}

class BurstRate {
  final int _value;
  const BurstRate._(this._value);

  int get value => _value;

  static const BurstRate threePerSecond = BurstRate._(0x00);
  static const BurstRate fivePerSecond = BurstRate._(0x01);
  static const BurstRate tenPerSecond = BurstRate._(0x02);
  static const BurstRate tenPerTwoSeconds = BurstRate._(0x03);
  static const BurstRate thirtyPerSecond = BurstRate._(0x04);
  static const BurstRate thirtyPerTwoSeconds = BurstRate._(0x05);
  static const BurstRate thirtyPerThreeSeconds = BurstRate._(0x06);

  static const List<BurstRate> all = [
    threePerSecond,
    fivePerSecond,
    tenPerSecond,
    tenPerTwoSeconds,
    thirtyPerSecond,
    thirtyPerTwoSeconds,
    thirtyPerThreeSeconds,
  ];

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is BurstRate && _value == other._value;

  @override
  int get hashCode => _value.hashCode;

  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (_value) {
      case 0x00:
        return l10n.burstRate3PerSec;
      case 0x01:
        return l10n.burstRate5PerSec;
      case 0x02:
        return l10n.burstRate10PerSec;
      case 0x03:
        return l10n.burstRate10Per2Sec;
      case 0x04:
        return l10n.burstRate30PerSec;
      case 0x05:
        return l10n.burstRate30Per2Sec;
      case 0x06:
        return l10n.burstRate30Per3Sec;
      default:
        return toHex(_value);
    }
  }
}

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

class Volume {
  final int _value;

  const Volume._(this._value);

  int get value => _value;

  static const Volume mute = Volume._(0x00);
  static const Volume percent70 = Volume._(0x01);
  static const Volume percent100 = Volume._(0x02);

  static const List<Volume> all = [mute, percent70, percent100];

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Volume && _value == other._value;

  @override
  int get hashCode => _value.hashCode;

  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (_value) {
      case 0x00:
        return l10n.volumeOff;
      case 0x01:
        return l10n.volumeLow;
      case 0x02:
        return l10n.volumeHigh;
      default:
        return toHex(_value);
    }
  }
}

class LED {
  final int _value;

  const LED._(this._value);

  int get value => _value;

  static const LED off = LED._(0x00);
  static const LED twoLeds = LED._(0x01);
  static const LED fourLeds = LED._(0x02);

  static const List<LED> all = [off, twoLeds, fourLeds];

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is LED && _value == other._value;

  @override
  int get hashCode => _value.hashCode;

  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (_value) {
      case 0x00:
        return l10n.ledOff;
      case 0x01:
        return l10n.ledTwo;
      case 0x02:
        return l10n.ledFour;
      default:
        return toHex(_value);
    }
  }
}

class DefaultCameraMode {
  final int _value;
  const DefaultCameraMode._(this._value);

  int get value => _value;

  static const DefaultCameraMode videoMode = DefaultCameraMode._(0x00);
  static const DefaultCameraMode photoMode = DefaultCameraMode._(0x01);
  static const DefaultCameraMode burstMode = DefaultCameraMode._(0x02);
  static const DefaultCameraMode timeLapseMode = DefaultCameraMode._(0x03);

  static const List<DefaultCameraMode> all = [
    videoMode,
    photoMode,
    burstMode,
    timeLapseMode,
  ];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DefaultCameraMode && _value == other._value;

  @override
  int get hashCode => _value.hashCode;

  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (_value) {
      case 0x00:
        return l10n.defaultModeVideo;
      case 0x01:
        return l10n.defaultModePhoto;
      case 0x02:
        return l10n.defaultModeBurst;
      case 0x03:
        return l10n.defaultModeTimeLapse;
      default:
        return toHex(_value);
    }
  }
}

class VideoModes {
  final int _value;
  const VideoModes._(this._value);

  int get value => _value;

  static const VideoModes ntsc = VideoModes._(0x00);
  static const VideoModes pal = VideoModes._(0x01);

  static const List<VideoModes> all = [ntsc, pal];

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is VideoModes && _value == other._value;

  @override
  int get hashCode => _value.hashCode;

  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (_value) {
      case 0x00:
        return l10n.videoModeNtsc;
      case 0x01:
        return l10n.videoModePal;
      default:
        return toHex(_value);
    }
  }

  static final videoModesFrameRates = {
    ntsc: [
      FPS.fps15,
      FPS.fps12,
      FPS.fps24,
      FPS.fps30,
      FPS.fps48,
      FPS.fps60,
      FPS.fps100,
      FPS.fps120,
      FPS.fps240,
    ],
    pal: [
      FPS.fps12_5,
      FPS.fps12,
      FPS.fps24,
      FPS.fps25,
      FPS.fps48,
      FPS.fps50,
      FPS.fps100,
      FPS.fps240,
    ],
  };
}

class Orientation {
  final int _value;
  const Orientation._(this._value);

  int get value => _value;

  static const Orientation up = Orientation._(0x00);
  static const Orientation down = Orientation._(0x01);

  static const List<Orientation> all = [up, down];

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Orientation && _value == other._value;

  @override
  int get hashCode => _value.hashCode;

  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (_value) {
      case 0x00:
        return l10n.orientationUp;
      case 0x01:
        return l10n.orientationDown;
      default:
        return toHex(_value);
    }
  }
}

class OneButton {
  final int _value;
  const OneButton._(this._value);

  int get value => _value;

  static const OneButton off = OneButton._(0x00);
  static const OneButton on = OneButton._(0x01);

  static const List<OneButton> all = [off, on];

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is OneButton && _value == other._value;

  @override
  int get hashCode => _value.hashCode;

  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (_value) {
      case 0x00:
        return l10n.volumeOff;
      case 0x01:
        return l10n.buttonOn;
      default:
        return toHex(_value);
    }
  }
}

class AutoPowerOff {
  final int _value;
  const AutoPowerOff._(this._value);

  int get value => _value;

  static const AutoPowerOff never = AutoPowerOff._(0x00);
  static const AutoPowerOff after1Minute = AutoPowerOff._(0x01);
  static const AutoPowerOff after2Minutes = AutoPowerOff._(0x02);
  static const AutoPowerOff after5Minutes = AutoPowerOff._(0x03);

  static const List<AutoPowerOff> all = [
    never,
    after1Minute,
    after2Minutes,
    after5Minutes,
  ];

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AutoPowerOff && _value == other._value;

  @override
  int get hashCode => _value.hashCode;

  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (_value) {
      case 0x00:
        return l10n.autoPowerOffNever;
      case 0x01:
        return l10n.autoPowerOff1Min;
      case 0x02:
        return l10n.autoPowerOff2Min;
      case 0x03:
        return l10n.autoPowerOff5Min;
      default:
        return toHex(_value);
    }
  }
}
