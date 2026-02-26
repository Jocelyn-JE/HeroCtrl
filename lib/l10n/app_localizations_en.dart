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
  String get connectingToCamera => 'Connecting to camera...\nIt will briefly turn on.';

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
  String get switchOffCameraOnDisconnectSubtitle => 'Automatically power off the camera when disconnecting from it';
}
