class GoProEndpoints {
  static const String baseUrl = 'http://10.5.5.9';
  static const String livestreamUrl = '$baseUrl/live/amba.m3u8';
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
  static const String off = '00';
  static const String on = '01';
  static const powerStrings = {Power.off: 'Off', Power.on: 'On'};
}

class Shutter {
  static const String stop = '00';
  static const String start = '01';
  static const shutterStrings = {Shutter.stop: 'Stop', Shutter.start: 'Start'};
}

class VideoPreview {
  static const String off = '00';
  static const String on = '02';
  static const videoPreviewStrings = {
    VideoPreview.off: 'Off',
    VideoPreview.on: 'On',
  };
}

class Locate {
  static const String off = '00';
  static const String on = '01';
  static const locateStrings = {Locate.off: 'Off', Locate.on: 'On'};
}

class CameraMode {
  static const String videoMode = '00';
  static const String photoMode = '01';
  static const String burstMode = '02';
  // static const String timeLapseMode = '03';
  static const String timerMode = '04';
  static const String hdmiMode = '05';
  // static const String videoModeForced = '06';
  // static const String settings = '07';

  static const cameraModeStrings = {
    CameraMode.videoMode: 'Video',
    CameraMode.photoMode: 'Photo',
    CameraMode.burstMode: 'Burst',
    CameraMode.hdmiMode: 'HDMI Output',
  };
}

class VideoResolution {
  static const String wvga240fps = '00';
  static const String res720p = '01';
  static const String res960p = '02';
  static const String res1080p = '03';
  static const String res1440p = '04';
  static const String res2_7k = '05';
  static const String res4k = '06';
  static const String res2_7k_17_9 = '07';
  static const String res4k_17_9 = '08';
  static const String res1080pSuperView = '09';
  static const String res720pSuperView = '0a';
  static const videoResolutionStrings = {
    VideoResolution.wvga240fps: 'WVGA 240fps',
    VideoResolution.res720p: '720p',
    VideoResolution.res960p: '960p',
    VideoResolution.res1080p: '1080p',
    VideoResolution.res1440p: '1440p',
    VideoResolution.res2_7k: '2.7K',
    VideoResolution.res4k: '4K',
    VideoResolution.res2_7k_17_9: '2.7K 17:9',
    VideoResolution.res4k_17_9: '4K 17:9',
    VideoResolution.res1080pSuperView: '1080p SuperView',
    VideoResolution.res720pSuperView: '720p SuperView',
  };
  static const videoResolutionSupportedFPS = {
    VideoResolution.wvga240fps: [FPS.fps240],
    VideoResolution.res720p: [FPS.fps50, FPS.fps60, FPS.fps120],
    VideoResolution.res960p: [FPS.fps48, FPS.fps50, FPS.fps60, FPS.fps100],
    VideoResolution.res1080p: [
      FPS.fps24,
      FPS.fps25,
      FPS.fps30,
      FPS.fps48,
      FPS.fps50,
      FPS.fps60,
    ],
    VideoResolution.res1440p: [FPS.fps24, FPS.fps25, FPS.fps30, FPS.fps48],
    VideoResolution.res2_7k: [FPS.fps25, FPS.fps30],
    VideoResolution.res4k: [FPS.fps12_5, FPS.fps15],
    VideoResolution.res2_7k_17_9: [FPS.fps24],
    VideoResolution.res4k_17_9: [FPS.fps12],
    VideoResolution.res1080pSuperView: [
      FPS.fps24,
      FPS.fps25,
      FPS.fps30,
      FPS.fps48,
    ],
    VideoResolution.res720pSuperView: [
      FPS.fps48,
      FPS.fps50,
      FPS.fps60,
      FPS.fps100,
    ],
  };
}

class FOV {
  static const String wide = '00';
  static const String medium = '01';
  static const String narrow = '02';
  static const fovStrings = {
    FOV.narrow: 'Narrow',
    FOV.medium: 'Medium',
    FOV.wide: 'Wide',
  };
}

class FPS {
  static const String fps12 = '00';
  static const String fps12_5 = '0b';
  static const String fps15 = '01';
  static const String fps24 = '02';
  static const String fps25 = '03';
  static const String fps30 = '04';
  static const String fps48 = '05';
  static const String fps50 = '06';
  static const String fps60 = '07';
  static const String fps100 = '08';
  static const String fps120 = '09';
  static const String fps240 = '0a';
  static const fpsStrings = {
    FPS.fps12: '12fps',
    FPS.fps12_5: '12.5fps',
    FPS.fps15: '15fps',
    FPS.fps24: '24fps',
    FPS.fps25: '25fps',
    FPS.fps30: '30fps',
    FPS.fps48: '48fps',
    FPS.fps50: '50fps',
    FPS.fps60: '60fps',
    FPS.fps100: '100fps',
    FPS.fps120: '120fps',
    FPS.fps240: '240fps',
  };
}

class VideoAndPhotoInterval {
  static const String off = '00';
  static const String every5s = '01';
  static const String every10s = '02';
  static const String every30s = '03';
  static const String every60s = '04';
  static const videoAndPhotoIntervalStrings = {
    VideoAndPhotoInterval.off: 'Off',
    VideoAndPhotoInterval.every5s: 'Every 5 seconds',
    VideoAndPhotoInterval.every10s: 'Every 10 seconds',
    VideoAndPhotoInterval.every30s: 'Every 30 seconds',
    VideoAndPhotoInterval.every60s: 'Every 60 seconds',
  };
}

class LoopVideoDuration {
  static const String off = '00';
  static const String fiveMinutes = '01';
  static const String twentyMinutes = '02';
  static const String oneHour = '03';
  static const String twoHours = '04';
  static const String maxStorage = '05';
  static const loopVideoDurationStrings = {
    LoopVideoDuration.off: 'Off',
    LoopVideoDuration.fiveMinutes: '5 Minutes',
    LoopVideoDuration.twentyMinutes: '20 Minutes',
    LoopVideoDuration.oneHour: '1 Hour',
    LoopVideoDuration.twoHours: '2 Hours',
    LoopVideoDuration.maxStorage: 'Max Storage',
  };
}

class LowLight {
  static const String off = '00';
  static const String on = '01';
  static const lowLightStrings = {LowLight.off: 'Off', LowLight.on: 'On'};
}

class SpotMeter {
  static const String off = '00';
  static const String on = '01';
  static const spotMeterStrings = {SpotMeter.off: 'Off', SpotMeter.on: 'On'};
}

class PhotoResolution {
  static const String res5MPmedium = '03';
  static const String res7MPmedium = '06';
  static const String res7MPwide = '04';
  static const String res12MPwide = '05';
  static const photoResolutionStrings = {
    PhotoResolution.res5MPmedium: '5MP Medium',
    PhotoResolution.res7MPmedium: '7MP Medium',
    PhotoResolution.res7MPwide: '7MP Wide',
    PhotoResolution.res12MPwide: '12MP Wide',
  };
}

class TimelapseInterval {
  static const String halfASecond = '00';
  static const String oneSecond = '01';
  static const String twoSeconds = '02';
  static const String fiveSeconds = '05';
  static const String tenSeconds = '0a';
  static const String thirtySeconds = '1e';
  static const String sixtySeconds = '3c';
  static const timelapseIntervalStrings = {
    TimelapseInterval.halfASecond: '0.5 Seconds',
    TimelapseInterval.oneSecond: '1 Second',
    TimelapseInterval.twoSeconds: '2 Seconds',
    TimelapseInterval.fiveSeconds: '5 Seconds',
    TimelapseInterval.tenSeconds: '10 Seconds',
    TimelapseInterval.thirtySeconds: '30 Seconds',
    TimelapseInterval.sixtySeconds: '60 Seconds',
  };
}

class ContinuousShot {
  static const String off = '00';
  static const String threePhotos = '03';
  static const String fivePhotos = '05';
  static const String tenPhotos = '0a';
  static const continuousShotStrings = {
    ContinuousShot.off: 'Off',
    ContinuousShot.threePhotos: '3 Photos',
    ContinuousShot.fivePhotos: '5 Photos',
    ContinuousShot.tenPhotos: '10 Photos',
  };
}

class BurstRate {
  static const String threePerSecond = '00';
  static const String fivePerSecond = '01';
  static const String tenPerSecond = '02';
  static const String tenPerTwoSeconds = '03';
  static const String thirtyPerSecond = '04';
  static const String thirtyPerTwoSeconds = '05';
  static const String thirtyPerThreeSeconds = '06';
  static const burstRateStrings = {
    BurstRate.threePerSecond: '3 Photos/s',
    BurstRate.fivePerSecond: '5 Photos/s',
    BurstRate.tenPerSecond: '10 Photos/s',
    BurstRate.tenPerTwoSeconds: '10 Photos/2s',
    BurstRate.thirtyPerSecond: '30 Photos/s',
    BurstRate.thirtyPerTwoSeconds: '30 Photos/2s',
    BurstRate.thirtyPerThreeSeconds: '30 Photos/3s',
  };
}

class ProTune {
  static const String off = '00';
  static const String on = '01';
  static const proTuneStrings = {ProTune.off: 'Off', ProTune.on: 'On'};
}

class WhiteBalance {
  static const String auto = '00';
  static const String k3000 = '01';
  static const String k5500 = '02';
  static const String k6500 = '03';
  static const String camRaw = '04';
  static const whiteBalanceStrings = {
    WhiteBalance.auto: 'Auto',
    WhiteBalance.k3000: '3000K',
    WhiteBalance.k5500: '5500K',
    WhiteBalance.k6500: '6500K',
    WhiteBalance.camRaw: 'Cam RAW',
  };
}

class ExposureCompensation {
  static const String minusTwo = '06';
  static const String minusOneAndHalf = '07';
  static const String minusOne = '08';
  static const String minusHalf = '09';
  static const String zero = '0a';
  static const String plusHalf = '0b';
  static const String plusOne = '0c';
  static const String plusOneAndHalf = '0d';
  static const String plusTwo = '0e';
  static const exposureCompensationStrings = {
    ExposureCompensation.minusTwo: '-2',
    ExposureCompensation.minusOneAndHalf: '-1.5',
    ExposureCompensation.minusOne: '-1',
    ExposureCompensation.minusHalf: '-0.5',
    ExposureCompensation.zero: '0',
    ExposureCompensation.plusHalf: '+0.5',
    ExposureCompensation.plusOne: '+1',
    ExposureCompensation.plusOneAndHalf: '+1.5',
    ExposureCompensation.plusTwo: '+2',
  };
}

class Sharpness {
  static const String high = '00';
  static const String medium = '01';
  static const String low = '02';
  static const sharpnessStrings = {
    Sharpness.high: 'High',
    Sharpness.medium: 'Medium',
    Sharpness.low: 'Low',
  };
}

class ISOLimit {
  static const String iso6400 = '00';
  static const String iso1600 = '01';
  static const String iso400 = '02';
  static const isoModesStrings = {
    ISOLimit.iso6400: 'ISO 6400',
    ISOLimit.iso1600: 'ISO 1600',
    ISOLimit.iso400: 'ISO 400',
  };
}

class ColorProfile {
  static const String goPro = '00';
  static const String flat = '01';
  static const colorProfileStrings = {
    ColorProfile.goPro: 'GoPro Color',
    ColorProfile.flat: 'Flat Color',
  };
}

class ProtuneVideoResolution {
  static const String res720p = '00';
  static const String res960p = '02';
  static const String res1080p = '03';
  static const String res1440p = '04';
  static const String res2_7k = '05';
  static const String res4k = '06';
  static const String res2_7k_17_9 = '07';
  static const String res4k_17_9 = '08';
  static const String res1080pSuperView = '09';
  static const String res720pSuperView = '0a';
  static const protuneVideoResolutionStrings = {
    ProtuneVideoResolution.res720p: '720p',
    ProtuneVideoResolution.res960p: '960p',
    ProtuneVideoResolution.res1080p: '1080p',
    ProtuneVideoResolution.res1440p: '1440p',
    ProtuneVideoResolution.res2_7k: '2.7K',
    ProtuneVideoResolution.res4k: '4K',
    ProtuneVideoResolution.res2_7k_17_9: '2.7K 17:9',
    ProtuneVideoResolution.res4k_17_9: '4K 17:9',
    ProtuneVideoResolution.res1080pSuperView: '1080p SuperView',
    ProtuneVideoResolution.res720pSuperView: '720p SuperView',
  };
  static const ProtuneVideoResolutionSupportedFPS = {
    ProtuneVideoResolution.res720p: [
      FPS.fps50,
      FPS.fps60,
      FPS.fps100,
      FPS.fps120,
    ],
    ProtuneVideoResolution.res960p: [FPS.fps50, FPS.fps60, FPS.fps100],
    ProtuneVideoResolution.res1080p: [
      FPS.fps24,
      FPS.fps25,
      FPS.fps30,
      FPS.fps48,
      FPS.fps50,
      FPS.fps60,
    ],
    ProtuneVideoResolution.res1440p: [
      FPS.fps24,
      FPS.fps25,
      FPS.fps30,
      FPS.fps48,
    ],
    ProtuneVideoResolution.res2_7k: [FPS.fps25, FPS.fps30],
    ProtuneVideoResolution.res4k: [FPS.fps12_5, FPS.fps15],
    ProtuneVideoResolution.res2_7k_17_9: [FPS.fps24],
    ProtuneVideoResolution.res4k_17_9: [FPS.fps12],
    ProtuneVideoResolution.res1080pSuperView: [
      FPS.fps24,
      FPS.fps25,
      FPS.fps30,
      FPS.fps48,
    ],
    ProtuneVideoResolution.res720pSuperView: [FPS.fps50, FPS.fps60, FPS.fps100],
  };
}

class Volume {
  static const String mute = '00';
  static const String percent70 = '01';
  static const String percent100 = '02';
  static const volumeStrings = {
    Volume.mute: 'Mute',
    Volume.percent70: '70%',
    Volume.percent100: '100%',
  };
}

class LED {
  static const String off = '00';
  static const String twoLeds = '01';
  static const String fourLeds = '02';
  static const ledStrings = {
    LED.off: 'Off',
    LED.twoLeds: 'Two LEDs (front and back)',
    LED.fourLeds: 'Four LEDs (front, back, and sides)',
  };
}

class DefaultCameraMode {
  static const String videoMode = '00';
  static const String photoMode = '01';
  static const String burstMode = '02';
  static const String timeLapseMode = '03';

  static const defaultCameraModetrings = {
    DefaultCameraMode.videoMode: 'Video',
    DefaultCameraMode.photoMode: 'Photo',
    DefaultCameraMode.burstMode: 'Burst',
    DefaultCameraMode.timeLapseMode: 'Time Lapse',
  };
}

class VideoModes {
  static const String ntsc = '00';
  static const String pal = '01';
  static const videoModesStrings = {
    VideoModes.ntsc: 'NTSC',
    VideoModes.pal: 'PAL',
  };
}

class Orientation {
  static const String up = '00';
  static const String down = '01';
  static const orientationStrings = {
    Orientation.up: 'Up',
    Orientation.down: 'Down',
  };
}

class OneButton {
  static const String off = '00';
  static const String on = '01';
  static const oneButtonStrings = {OneButton.off: 'Off', OneButton.on: 'On'};
}

class AutoPowerOff {
  static const String never = '00';
  static const String after1Minute = '01';
  static const String after2Minutes = '02';
  static const String after5Minutes = '03';
  static const autoPowerOffStrings = {
    AutoPowerOff.never: 'Never',
    AutoPowerOff.after1Minute: 'After 1 Minute',
    AutoPowerOff.after2Minutes: 'After 2 Minutes',
    AutoPowerOff.after5Minutes: 'After 5 Minutes',
  };
}
