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
  static const int off = 0x00;
  static const int on = 0x01;

  static String getLocalizedName(BuildContext context, int value) {
    final l10n = AppLocalizations.of(context)!;
    switch (value) {
      case off:
        return l10n.volumeOff;
      case on:
        return l10n.buttonOn;
      default:
        return toHex(value);
    }
  }
}

class Shutter {
  static const int stop = 0x00;
  static const int start = 0x01;

  static String getLocalizedName(BuildContext context, int value) {
    final l10n = AppLocalizations.of(context)!;
    switch (value) {
      case stop:
        return l10n.volumeOff;
      case start:
        return l10n.buttonOn;
      default:
        return toHex(value);
    }
  }
}

class VideoPreview {
  static const int off = 0x00;
  static const int on = 0x02;

  static String getLocalizedName(BuildContext context, int value) {
    final l10n = AppLocalizations.of(context)!;
    switch (value) {
      case off:
        return l10n.volumeOff;
      case on:
        return l10n.buttonOn;
      default:
        return toHex(value);
    }
  }
}

class Locate {
  static const int off = 0x00;
  static const int on = 0x01;

  static String getLocalizedName(BuildContext context, int value) {
    final l10n = AppLocalizations.of(context)!;
    switch (value) {
      case off:
        return l10n.volumeOff;
      case on:
        return l10n.buttonOn;
      default:
        return toHex(value);
    }
  }
}

class CameraMode {
  static const int videoMode = 0x00;
  static const int photoMode = 0x01;
  static const int burstMode = 0x02;
  static const int timerMode = 0x04;
  static const int hdmiMode = 0x05;

  static const modes = [videoMode, photoMode, burstMode, timerMode, hdmiMode];

  static String getLocalizedName(BuildContext context, int value) {
    final l10n = AppLocalizations.of(context)!;
    switch (value) {
      case videoMode:
        return l10n.defaultModeVideo;
      case photoMode:
        return l10n.defaultModePhoto;
      case burstMode:
        return l10n.defaultModeBurst;
      case timerMode:
        return l10n.cameraModeTimer;
      case hdmiMode:
        return l10n.cameraModeHdmi;
      default:
        return toHex(value);
    }
  }
}

class VideoResolution {
  static const int wvga240fps = 0x00;
  static const int res720p = 0x01;
  static const int res960p = 0x02;
  static const int res1080p = 0x03;
  static const int res1440p = 0x04;
  static const int res2_7k = 0x05;
  static const int res4k = 0x06;
  static const int res2_7k_17_9 = 0x07;
  static const int res4k_17_9 = 0x08;
  static const int res1080pSuperView = 0x09;
  static const int res720pSuperView = 0x0a;

  static const videoResolutions = [
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

  /// Returns the localized display name for a given resolution code
  static String getLocalizedName(BuildContext context, int resolutionCode) {
    final l10n = AppLocalizations.of(context)!;
    switch (resolutionCode) {
      case wvga240fps:
        return l10n.resolutionWvga240fps;
      case res720p:
        return l10n.resolution720p;
      case res960p:
        return l10n.resolution960p;
      case res1080p:
        return l10n.resolution1080p;
      case res1440p:
        return l10n.resolution1440p;
      case res2_7k:
        return l10n.resolution2_7k;
      case res4k:
        return l10n.resolution4k;
      case res2_7k_17_9:
        return l10n.resolution2_7k_17_9;
      case res4k_17_9:
        return l10n.resolution4k_17_9;
      case res1080pSuperView:
        return l10n.resolution1080pSuperView;
      case res720pSuperView:
        return l10n.resolution720pSuperView;
      default:
        return toHex(resolutionCode);
    }
  }

  static const videoResolutionSupportedFPS = {
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
    res1080pSuperView: [FPS.fps24, FPS.fps25, FPS.fps30, FPS.fps48],
    res720pSuperView: [FPS.fps48, FPS.fps50, FPS.fps60, FPS.fps100],
  };
}

class FOV {
  static const int wide = 0x00;
  static const int medium = 0x01;
  static const int narrow = 0x02;

  static String getLocalizedName(BuildContext context, int value) {
    final l10n = AppLocalizations.of(context)!;
    switch (value) {
      case wide:
        return l10n.fovWide;
      case medium:
        return l10n.fovMedium;
      case narrow:
        return l10n.fovNarrow;
      default:
        return toHex(value);
    }
  }
}

class FPS {
  static const int fps12 = 0x00;
  static const int fps12_5 = 0x0b;
  static const int fps15 = 0x01;
  static const int fps24 = 0x02;
  static const int fps25 = 0x03;
  static const int fps30 = 0x04;
  static const int fps48 = 0x05;
  static const int fps50 = 0x06;
  static const int fps60 = 0x07;
  static const int fps100 = 0x08;
  static const int fps120 = 0x09;
  static const int fps240 = 0x0a;

  static String getLocalizedName(BuildContext context, int value) {
    switch (value) {
      case fps12:
        return '12fps';
      case fps12_5:
        return '12.5fps';
      case fps15:
        return '15fps';
      case fps24:
        return '24fps';
      case fps25:
        return '25fps';
      case fps30:
        return '30fps';
      case fps48:
        return '48fps';
      case fps50:
        return '50fps';
      case fps60:
        return '60fps';
      case fps100:
        return '100fps';
      case fps120:
        return '120fps';
      case fps240:
        return '240fps';
      default:
        return '${toHex(value)}fps';
    }
  }
}

class VideoAndPhotoInterval {
  static const int off = 0x00;
  static const int every5s = 0x01;
  static const int every10s = 0x02;
  static const int every30s = 0x03;
  static const int every60s = 0x04;

  static String getLocalizedName(BuildContext context, int value) {
    final l10n = AppLocalizations.of(context)!;
    switch (value) {
      case off:
        return l10n.volumeOff;
      case every5s:
        return l10n.videoAndPhotoEvery5s;
      case every10s:
        return l10n.videoAndPhotoEvery10s;
      case every30s:
        return l10n.videoAndPhotoEvery30s;
      case every60s:
        return l10n.videoAndPhotoEvery60s;
      default:
        return toHex(value);
    }
  }
}

class LoopVideoDuration {
  static const int off = 0x00;
  static const int fiveMinutes = 0x01;
  static const int twentyMinutes = 0x02;
  static const int oneHour = 0x03;
  static const int twoHours = 0x04;
  static const int maxStorage = 0x05;

  static String getLocalizedName(BuildContext context, int value) {
    final l10n = AppLocalizations.of(context)!;
    switch (value) {
      case off:
        return l10n.volumeOff;
      case fiveMinutes:
        return l10n.loopVideo5Min;
      case twentyMinutes:
        return l10n.loopVideo20Min;
      case oneHour:
        return l10n.loopVideo1Hour;
      case twoHours:
        return l10n.loopVideo2Hour;
      case maxStorage:
        return l10n.loopVideoMaxStorage;
      default:
        return toHex(value);
    }
  }
}

class LowLight {
  static const int off = 0x00;
  static const int on = 0x01;

  static String getLocalizedName(BuildContext context, int value) {
    final l10n = AppLocalizations.of(context)!;
    switch (value) {
      case off:
        return l10n.lowLightOff;
      case on:
        return l10n.lowLightOn;
      default:
        return toHex(value);
    }
  }
}

class SpotMeter {
  static const int off = 0x00;
  static const int on = 0x01;

  static String getLocalizedName(BuildContext context, int value) {
    final l10n = AppLocalizations.of(context)!;
    switch (value) {
      case off:
        return l10n.spotMeterOff;
      case on:
        return l10n.spotMeterOn;
      default:
        return toHex(value);
    }
  }
}

class PhotoResolution {
  static const int res5MPmedium = 0x03;
  static const int res7MPwide = 0x04;
  static const int res12MPwide = 0x05;
  static const int res7MPmedium = 0x06;

  static String getLocalizedName(BuildContext context, int value) {
    final l10n = AppLocalizations.of(context)!;
    switch (value) {
      case res5MPmedium:
        return l10n.photoResolution5MpMedium;
      case res7MPmedium:
        return l10n.photoResolution7MpMedium;
      case res7MPwide:
        return l10n.photoResolution7MpWide;
      case res12MPwide:
        return l10n.photoResolution12MpWide;
      default:
        return toHex(value);
    }
  }
}

class TimelapseInterval {
  static const int halfASecond = 0x00;
  static const int oneSecond = 0x01;
  static const int twoSeconds = 0x02;
  static const int fiveSeconds = 0x05;
  static const int tenSeconds = 0x0a;
  static const int thirtySeconds = 0x1e;
  static const int sixtySeconds = 0x3c;

  static String getLocalizedName(BuildContext context, int value) {
    final l10n = AppLocalizations.of(context)!;
    switch (value) {
      case halfASecond:
        return l10n.timelapse0_5Sec;
      case oneSecond:
        return l10n.timelapse1Sec;
      case twoSeconds:
        return l10n.timelapse2Sec;
      case fiveSeconds:
        return l10n.timelapse5Sec;
      case tenSeconds:
        return l10n.timelapse10Sec;
      case thirtySeconds:
        return l10n.timelapse30Sec;
      case sixtySeconds:
        return l10n.timelapse60Sec;
      default:
        return toHex(value);
    }
  }
}

class ContinuousShot {
  static const int off = 0x00;
  static const int threePhotos = 0x03;
  static const int fivePhotos = 0x05;
  static const int tenPhotos = 0x0a;

  static String getLocalizedName(BuildContext context, int value) {
    final l10n = AppLocalizations.of(context)!;
    switch (value) {
      case off:
        return l10n.volumeOff;
      case threePhotos:
        return l10n.continuousShot3Photos;
      case fivePhotos:
        return l10n.continuousShot5Photos;
      case tenPhotos:
        return l10n.continuousShot10Photos;
      default:
        return toHex(value);
    }
  }
}

class BurstRate {
  static const int threePerSecond = 0x00;
  static const int fivePerSecond = 0x01;
  static const int tenPerSecond = 0x02;
  static const int tenPerTwoSeconds = 0x03;
  static const int thirtyPerSecond = 0x04;
  static const int thirtyPerTwoSeconds = 0x05;
  static const int thirtyPerThreeSeconds = 0x06;

  static String getLocalizedName(BuildContext context, int value) {
    final l10n = AppLocalizations.of(context)!;
    switch (value) {
      case threePerSecond:
        return l10n.burstRate3PerSec;
      case fivePerSecond:
        return l10n.burstRate5PerSec;
      case tenPerSecond:
        return l10n.burstRate10PerSec;
      case tenPerTwoSeconds:
        return l10n.burstRate10Per2Sec;
      case thirtyPerSecond:
        return l10n.burstRate30PerSec;
      case thirtyPerTwoSeconds:
        return l10n.burstRate30Per2Sec;
      case thirtyPerThreeSeconds:
        return l10n.burstRate30Per3Sec;
      default:
        return toHex(value);
    }
  }
}

class ProTune {
  static const int off = 0x00;
  static const int on = 0x01;

  static String getLocalizedName(BuildContext context, int value) {
    final l10n = AppLocalizations.of(context)!;
    switch (value) {
      case off:
        return l10n.protuneOff;
      case on:
        return l10n.protuneOn;
      default:
        return toHex(value);
    }
  }
}

class WhiteBalance {
  static const int auto = 0x00;
  static const int k3000 = 0x01;
  static const int k5500 = 0x02;
  static const int k6500 = 0x03;
  static const int camRaw = 0x04;

  static String getLocalizedName(BuildContext context, int value) {
    final l10n = AppLocalizations.of(context)!;
    switch (value) {
      case auto:
        return l10n.whiteBalanceAuto;
      case k3000:
        return l10n.whiteBalance3000K;
      case k5500:
        return l10n.whiteBalance5500K;
      case k6500:
        return l10n.whiteBalance6500K;
      case camRaw:
        return l10n.whiteBalanceCamRaw;
      default:
        return toHex(value);
    }
  }
}

class ExposureCompensation {
  static const int minusTwo = 0x06;
  static const int minusOneAndHalf = 0x07;
  static const int minusOne = 0x08;
  static const int minusHalf = 0x09;
  static const int zero = 0x0a;
  static const int plusHalf = 0x0b;
  static const int plusOne = 0x0c;
  static const int plusOneAndHalf = 0x0d;
  static const int plusTwo = 0x0e;

  static String getLocalizedName(BuildContext context, int value) {
    final l10n = AppLocalizations.of(context)!;
    switch (value) {
      case minusTwo:
        return l10n.exposureCompensation2Minus;
      case minusOneAndHalf:
        return l10n.exposureCompensation1_5Minus;
      case minusOne:
        return l10n.exposureCompensation1Minus;
      case minusHalf:
        return l10n.exposureCompensation0_5Minus;
      case zero:
        return l10n.exposureCompensation0;
      case plusHalf:
        return l10n.exposureCompensation0_5Plus;
      case plusOne:
        return l10n.exposureCompensation1Plus;
      case plusOneAndHalf:
        return l10n.exposureCompensation1_5Plus;
      case plusTwo:
        return l10n.exposureCompensation2Plus;
      default:
        return toHex(value);
    }
  }
}

class Sharpness {
  static const int high = 0x00;
  static const int medium = 0x01;
  static const int low = 0x02;

  static String getLocalizedName(BuildContext context, int value) {
    final l10n = AppLocalizations.of(context)!;
    switch (value) {
      case high:
        return l10n.sharpnessHigh;
      case medium:
        return l10n.sharpnessMedium;
      case low:
        return l10n.sharpnessLow;
      default:
        return toHex(value);
    }
  }
}

class ISOLimit {
  static const int iso6400 = 0x00;
  static const int iso1600 = 0x01;
  static const int iso400 = 0x02;

  static String getLocalizedName(BuildContext context, int value) {
    final l10n = AppLocalizations.of(context)!;
    switch (value) {
      case iso6400:
        return l10n.isoLimit6400;
      case iso1600:
        return l10n.isoLimit1600;
      case iso400:
        return l10n.isoLimit400;
      default:
        return toHex(value);
    }
  }
}

class ColorProfile {
  static const int goPro = 0x00;
  static const int flat = 0x01;

  static String getLocalizedName(BuildContext context, int value) {
    final l10n = AppLocalizations.of(context)!;
    switch (value) {
      case goPro:
        return l10n.colorProfileGoPro;
      case flat:
        return l10n.colorProfileFlat;
      default:
        return toHex(value);
    }
  }
}

class ProtuneVideoResolution {
  static const int res720p = 0x00;
  static const int res960p = 0x02;
  static const int res1080p = 0x03;
  static const int res1440p = 0x04;
  static const int res2_7k = 0x05;
  static const int res4k = 0x06;
  static const int res2_7k_17_9 = 0x07;
  static const int res4k_17_9 = 0x08;
  static const int res1080pSuperView = 0x09;
  static const int res720pSuperView = 0x0a;

  static String getLocalizedName(BuildContext context, int value) {
    final l10n = AppLocalizations.of(context)!;
    switch (value) {
      case res720p:
        return l10n.resolution720p;
      case res960p:
        return l10n.resolution960p;
      case res1080p:
        return l10n.resolution1080p;
      case res1440p:
        return l10n.resolution1440p;
      case res2_7k:
        return l10n.resolution2_7k;
      case res4k:
        return l10n.resolution4k;
      case res2_7k_17_9:
        return l10n.resolution2_7k_17_9;
      case res4k_17_9:
        return l10n.resolution4k_17_9;
      case res1080pSuperView:
        return l10n.resolution1080pSuperView;
      case res720pSuperView:
        return l10n.resolution720pSuperView;
      default:
        return toHex(value);
    }
  }

  static const protuneVideoResolutionSupportedFPS = {
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
  static const int mute = 0x00;
  static const int percent70 = 0x01;
  static const int percent100 = 0x02;

  static String getLocalizedName(BuildContext context, int value) {
    final l10n = AppLocalizations.of(context)!;
    switch (value) {
      case mute:
        return l10n.volumeOff;
      case percent70:
        return l10n.volumeLow;
      case percent100:
        return l10n.volumeHigh;
      default:
        return toHex(value);
    }
  }
}

class LED {
  static const int off = 0x00;
  static const int twoLeds = 0x01;
  static const int fourLeds = 0x02;

  static String getLocalizedName(BuildContext context, int value) {
    final l10n = AppLocalizations.of(context)!;
    switch (value) {
      case off:
        return l10n.ledOff;
      case twoLeds:
        return l10n.ledTwo;
      case fourLeds:
        return l10n.ledFour;
      default:
        return toHex(value);
    }
  }
}

class DefaultCameraMode {
  static const int videoMode = 0x00;
  static const int photoMode = 0x01;
  static const int burstMode = 0x02;
  static const int timeLapseMode = 0x03;

  static String getLocalizedName(BuildContext context, int value) {
    final l10n = AppLocalizations.of(context)!;
    switch (value) {
      case videoMode:
        return l10n.defaultModeVideo;
      case photoMode:
        return l10n.defaultModePhoto;
      case burstMode:
        return l10n.defaultModeBurst;
      case timeLapseMode:
        return l10n.defaultModeTimeLapse;
      default:
        return toHex(value);
    }
  }
}

class VideoModes {
  static const int ntsc = 0x00;
  static const int pal = 0x01;

  static String getLocalizedName(BuildContext context, int value) {
    final l10n = AppLocalizations.of(context)!;
    switch (value) {
      case ntsc:
        return l10n.videoModeNtsc;
      case pal:
        return l10n.videoModePal;
      default:
        return toHex(value);
    }
  }

  static const videoModesFrameRates = {
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
  static const int up = 0x00;
  static const int down = 0x01;

  static String getLocalizedName(BuildContext context, int value) {
    final l10n = AppLocalizations.of(context)!;
    switch (value) {
      case up:
        return l10n.orientationUp;
      case down:
        return l10n.orientationDown;
      default:
        return toHex(value);
    }
  }
}

class OneButton {
  static const int off = 0x00;
  static const int on = 0x01;

  static String getLocalizedName(BuildContext context, int value) {
    final l10n = AppLocalizations.of(context)!;
    switch (value) {
      case off:
        return l10n.volumeOff;
      case on:
        return l10n.buttonOn;
      default:
        return toHex(value);
    }
  }
}

class AutoPowerOff {
  static const int never = 0x00;
  static const int after1Minute = 0x01;
  static const int after2Minutes = 0x02;
  static const int after5Minutes = 0x03;

  static String getLocalizedName(BuildContext context, int value) {
    final l10n = AppLocalizations.of(context)!;
    switch (value) {
      case never:
        return l10n.autoPowerOffNever;
      case after1Minute:
        return l10n.autoPowerOff1Min;
      case after2Minutes:
        return l10n.autoPowerOff2Min;
      case after5Minutes:
        return l10n.autoPowerOff5Min;
      default:
        return toHex(value);
    }
  }
}
