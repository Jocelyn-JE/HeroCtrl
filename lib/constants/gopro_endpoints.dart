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
