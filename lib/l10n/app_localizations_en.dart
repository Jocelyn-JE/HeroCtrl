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
  String get videoModeSettingTitle => 'Video Mode';

  @override
  String get videoModeSettingSubtitle => 'Switch between NTSC (multiples of 30fps) and PAL (multiples of 25fps) video modes.';

  @override
  String get videoModeNtsc => 'NTSC (30fps)';

  @override
  String get videoModePal => 'PAL (25fps)';

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
}
