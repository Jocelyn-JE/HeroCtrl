// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get password => 'Password';

  @override
  String get appTitle => 'HeroCtrl';

  @override
  String get settings => 'Settings';

  @override
  String get noRegisteredGoPros => 'No registered GoPros';

  @override
  String errorLabel(String error) {
    return 'Error: $error';
  }

  @override
  String get addCamera => 'Add a camera';

  @override
  String get aboutPeriodicScanning => 'About periodic scanning';

  @override
  String get periodicScanningInfo => 'The timer indicates when the next automatic scan will occur. WiFi scanning is limited by Android to 4 scans every 2 minutes per app. ';

  @override
  String get ok => 'OK';

  @override
  String get noCamerasFound => 'No cameras found.';

  @override
  String connectToCamera(String ssid) {
    return 'Connect to $ssid';
  }

  @override
  String get connectingToCamera => 'Connecting to camera...';

  @override
  String get cancel => 'Cancel';

  @override
  String get connect => 'Connect';

  @override
  String connectionError(String error) {
    return 'Error: $error';
  }

  @override
  String connectionFailed(String ssid) {
    return 'Failed to connect to $ssid. Please check that the camera is powered on and that the password is correct.';
  }

  @override
  String bssidLabel(String bssid) {
    return 'BSSID: $bssid';
  }

  @override
  String get forgetAllCameras => 'Forget all cameras';

  @override
  String get forgetAllCamerasConfirm => 'Are you sure you want to forget all cameras?';

  @override
  String get forget => 'Forget';

  @override
  String get switchOffCameraOnDisconnect => 'Switch off camera on disconnect';

  @override
  String get switchOffCameraOnDisconnectSubtitle => 'Automatically power off the camera when disconnecting from it (will stop any active recording).';

  @override
  String get cameraSettings => 'Camera Settings';

  @override
  String get ledSetting => 'LED Indicators';

  @override
  String get ledSettingSubtitle => 'Control which status LEDs are active on the camera.';

  @override
  String get ledOff => 'Off';

  @override
  String get ledTwo => '2 LEDs';

  @override
  String get ledFour => '4 LEDs';

  @override
  String get volumeSetting => 'Volume';

  @override
  String get volumeSettingSubtitle => 'Control the camera\'s speaker volume.';

  @override
  String get volumeOff => 'Off';

  @override
  String get volumeLow => '70%';

  @override
  String get volumeHigh => '100%';

  @override
  String get orientationUpsideDown => 'Upside-Down Mode';

  @override
  String get orientationUpsideDownSubtitle => 'Flip the camera image when mounted upside down.';

  @override
  String get timeSetting => 'Date & Time';

  @override
  String get timeSettingSubtitle => 'Sync the camera clock with the current device time.';

  @override
  String get timeSetToNow => 'Sync to Device Time';

  @override
  String get cameraCurrentTime => 'Camera time';

  @override
  String get videoStandardSettingTitle => 'Video Mode';

  @override
  String get videoStandardSettingSubtitle => 'Switch between NTSC (multiples of 30fps) and PAL (multiples of 25fps) video modes.\nRecommended use is NTSC in North America, Western South America, and Japan. PAL in Europe, Asia, Africa and everywhere else.';

  @override
  String get videoStandardNtsc => 'NTSC (30fps)';

  @override
  String get videoStandardPal => 'PAL (25fps)';

  @override
  String get cameraInfoTitle => 'Camera Information';

  @override
  String cameraModel(String model) {
    return 'Model: $model';
  }

  @override
  String cameraSerial(String serial) {
    return 'Serial number: H$serial';
  }

  @override
  String cameraMacAddress(String mac) {
    return 'MAC address: $mac';
  }

  @override
  String cameraVersion(String version) {
    return 'Firmware version: $version';
  }

  @override
  String cameraWifiSSID(String ssid) {
    return 'WiFi SSID: $ssid';
  }

  @override
  String cameraWifiPassword(String password) {
    return 'WiFi Password: $password';
  }

  @override
  String get defaultModeSetting => 'Default Camera Mode';

  @override
  String get defaultModeSettingSubtitle => 'Choose which mode the camera should start in when powered on.';

  @override
  String get defaultModeVideo => 'Video';

  @override
  String get defaultModePhoto => 'Photo';

  @override
  String get defaultModeTimeLapse => 'Time-Lapse';

  @override
  String get defaultModeBurst => 'Burst';

  @override
  String get locateCamera => 'Locate Camera';

  @override
  String get locateCameraSubtitle => 'Make the camera beep and flash its LEDs to help you find it.';

  @override
  String get locateCameraButton => 'Start Locating';

  @override
  String get locateCameraDialogTitle => 'Locating Camera';

  @override
  String get locateCameraDialogMessage => 'The camera is beeping and flashing. Tap Stop when you\'ve found it.';

  @override
  String get locateCameraStop => 'Stop';

  @override
  String get disconnectTitle => 'Disconnect & Turn Off';

  @override
  String get disconnectSubtitle => 'Turn off the camera and return to the home screen.';

  @override
  String get disconnectConfirmTitle => 'Turn Off Camera?';

  @override
  String get disconnectConfirmMessage => 'This will power off the camera and disconnect. Any active recording will be stopped.';

  @override
  String get disconnectConfirmButton => 'Turn Off';

  @override
  String get resolutionWvga240fps => 'WVGA 240  fps';

  @override
  String get resolution720p => '720p';

  @override
  String get resolution960p => '960p (4:3)';

  @override
  String get resolution1080p => '1080p';

  @override
  String get resolution1440p => '1440p (4:3)';

  @override
  String get resolution2_7k => '2.7K';

  @override
  String get resolution4k => '4K';

  @override
  String get resolution2_7k_17_9 => '2.7K (17:9)';

  @override
  String get resolution4k_17_9 => '4K (17:9)';

  @override
  String get resolution1080pSuperView => '1080p SuperView';

  @override
  String get resolution720pSuperView => '720p SuperView';

  @override
  String get buttonOn => 'On';

  @override
  String get buttonOff => 'Off';

  @override
  String get cameraModeTimer => 'Timer';

  @override
  String get cameraModeHdmi => 'HDMI Output';

  @override
  String get fovWide => 'Wide';

  @override
  String get fovMedium => 'Medium';

  @override
  String get fovNarrow => 'Narrow';

  @override
  String get videoAndPhotoEvery5s => 'Every 5 seconds';

  @override
  String get videoAndPhotoEvery10s => 'Every 10 seconds';

  @override
  String get videoAndPhotoEvery30s => 'Every 30 seconds';

  @override
  String get videoAndPhotoEvery60s => 'Every 60 seconds';

  @override
  String get loopVideo5Min => '5 Minutes';

  @override
  String get loopVideo20Min => '20 Minutes';

  @override
  String get loopVideo1Hour => '1 Hour';

  @override
  String get loopVideo2Hour => '2 Hours';

  @override
  String get loopVideoMaxStorage => 'Max Storage';

  @override
  String get photoResolution5MpMedium => '5MP Medium';

  @override
  String get photoResolution7MpMedium => '7MP Medium';

  @override
  String get photoResolution7MpWide => '7MP Wide';

  @override
  String get photoResolution12MpWide => '12MP Wide';

  @override
  String get timelapse0_5Sec => '0.5 Seconds';

  @override
  String get timelapse1Sec => '1 Second';

  @override
  String get timelapse2Sec => '2 Seconds';

  @override
  String get timelapse5Sec => '5 Seconds';

  @override
  String get timelapse10Sec => '10 Seconds';

  @override
  String get timelapse30Sec => '30 Seconds';

  @override
  String get timelapse60Sec => '60 Seconds';

  @override
  String get continuousShot3Photos => '3 Photos';

  @override
  String get continuousShot5Photos => '5 Photos';

  @override
  String get continuousShot10Photos => '10 Photos';

  @override
  String get burstRate3PerSec => '3 Photos/s';

  @override
  String get burstRate5PerSec => '5 Photos/s';

  @override
  String get burstRate10PerSec => '10 Photos/s';

  @override
  String get burstRate10Per2Sec => '10 Photos/2s';

  @override
  String get burstRate30PerSec => '30 Photos/s';

  @override
  String get burstRate30Per2Sec => '30 Photos/2s';

  @override
  String get burstRate30Per3Sec => '30 Photos/3s';

  @override
  String get protuneOn => 'Pro Tune On';

  @override
  String get protuneOff => 'Pro Tune Off';

  @override
  String get whiteBalanceAuto => 'Auto';

  @override
  String get whiteBalance3000K => '3000K';

  @override
  String get whiteBalance5500K => '5500K';

  @override
  String get whiteBalance6500K => '6500K';

  @override
  String get whiteBalanceCamRaw => 'Cam RAW';

  @override
  String get exposureCompensation2Plus => '+2.0';

  @override
  String get exposureCompensation1_5Plus => '+1.5';

  @override
  String get exposureCompensation1Plus => '+1.0';

  @override
  String get exposureCompensation0_5Plus => '+0.5';

  @override
  String get exposureCompensation0 => '0.0';

  @override
  String get exposureCompensation0_5Minus => '-0.5';

  @override
  String get exposureCompensation1Minus => '-1.0';

  @override
  String get exposureCompensation1_5Minus => '-1.5';

  @override
  String get exposureCompensation2Minus => '-2.0';

  @override
  String get sharpnessHigh => 'High';

  @override
  String get sharpnessMedium => 'Medium';

  @override
  String get sharpnessLow => 'Low';

  @override
  String get isoLimit6400 => 'ISO 6400';

  @override
  String get isoLimit1600 => 'ISO 1600';

  @override
  String get isoLimit400 => 'ISO 400';

  @override
  String get colorProfileGoPro => 'GoPro Color';

  @override
  String get colorProfileFlat => 'Flat Color';

  @override
  String get orientationUp => 'Normal';

  @override
  String get orientationDown => 'Upside Down';

  @override
  String get autoPowerOffNever => 'Never';

  @override
  String get autoPowerOff1Min => 'After 1 minute';

  @override
  String get autoPowerOff2Min => 'After 2 minutes';

  @override
  String get autoPowerOff5Min => 'After 5 minutes';

  @override
  String get lowLightOn => 'Low Light: On';

  @override
  String get lowLightOff => 'Low Light: Off';

  @override
  String get spotMeterOn => 'Spot Meter: On';

  @override
  String get spotMeterOff => 'Spot Meter: Off';

  @override
  String get fixStream => 'Fix Stream';

  @override
  String get batteryCriticallyLow => 'Battery critically low. Disconnecting from camera.';

  @override
  String get fps12 => '12 fps';

  @override
  String get fps12_5 => '12.5 fps';

  @override
  String get fps15 => '15 fps';

  @override
  String get fps24 => '24 fps';

  @override
  String get fps25 => '25 fps';

  @override
  String get fps30 => '30 fps';

  @override
  String get fps48 => '48 fps';

  @override
  String get fps50 => '50 fps';

  @override
  String get fps60 => '60 fps';

  @override
  String get fps100 => '100 fps';

  @override
  String get fps120 => '120 fps';

  @override
  String get fps240 => '240 fps';
}
