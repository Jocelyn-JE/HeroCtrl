import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en')
  ];

  /// Label for password input field
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Application title
  ///
  /// In en, this message translates to:
  /// **'HeroCtrl'**
  String get appTitle;

  /// Settings menu item
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Message when no GoPros are registered
  ///
  /// In en, this message translates to:
  /// **'No registered GoPros'**
  String get noRegisteredGoPros;

  /// Error message label
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String errorLabel(String error);

  /// Title for add camera screen
  ///
  /// In en, this message translates to:
  /// **'Add a camera'**
  String get addCamera;

  /// Dialog title about scanning
  ///
  /// In en, this message translates to:
  /// **'About periodic scanning'**
  String get aboutPeriodicScanning;

  /// Information about periodic WiFi scanning
  ///
  /// In en, this message translates to:
  /// **'The timer indicates when the next automatic scan will occur. WiFi scanning is limited by Android to 4 scans every 2 minutes per app. '**
  String get periodicScanningInfo;

  /// OK button text
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Message when no cameras are found
  ///
  /// In en, this message translates to:
  /// **'No cameras found.'**
  String get noCamerasFound;

  /// Dialog title for connecting to camera
  ///
  /// In en, this message translates to:
  /// **'Connect to {ssid}'**
  String connectToCamera(String ssid);

  /// Message while connecting to camera
  ///
  /// In en, this message translates to:
  /// **'Connecting to camera...'**
  String get connectingToCamera;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Connect button text
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get connect;

  /// Connection error message
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String connectionError(String error);

  /// Message when connection fails
  ///
  /// In en, this message translates to:
  /// **'Failed to connect to {ssid}. Please check that the camera is powered on and that the password is correct.'**
  String connectionFailed(String ssid);

  /// BSSID label
  ///
  /// In en, this message translates to:
  /// **'BSSID: {bssid}'**
  String bssidLabel(String bssid);

  /// Button to forget all cameras
  ///
  /// In en, this message translates to:
  /// **'Forget all cameras'**
  String get forgetAllCameras;

  /// Confirmation message for forgetting all cameras
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to forget all cameras?'**
  String get forgetAllCamerasConfirm;

  /// Forget button text
  ///
  /// In en, this message translates to:
  /// **'Forget'**
  String get forget;

  /// Settings option to automatically power off camera when disconnecting
  ///
  /// In en, this message translates to:
  /// **'Switch off camera on disconnect'**
  String get switchOffCameraOnDisconnect;

  /// Subtitle explaining the switch off camera on disconnect option
  ///
  /// In en, this message translates to:
  /// **'Automatically power off the camera when disconnecting from it (will stop any active recording).'**
  String get switchOffCameraOnDisconnectSubtitle;

  /// Title for camera settings screen
  ///
  /// In en, this message translates to:
  /// **'Camera Settings'**
  String get cameraSettings;

  /// Title for LED setting card
  ///
  /// In en, this message translates to:
  /// **'LED Indicators'**
  String get ledSetting;

  /// Subtitle explaining the LED setting
  ///
  /// In en, this message translates to:
  /// **'Control which status LEDs are active on the camera.'**
  String get ledSettingSubtitle;

  /// LED off option
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get ledOff;

  /// Two LEDs option
  ///
  /// In en, this message translates to:
  /// **'2 LEDs'**
  String get ledTwo;

  /// Four LEDs option
  ///
  /// In en, this message translates to:
  /// **'4 LEDs'**
  String get ledFour;

  /// Title for volume setting card
  ///
  /// In en, this message translates to:
  /// **'Volume'**
  String get volumeSetting;

  /// Subtitle explaining the volume setting
  ///
  /// In en, this message translates to:
  /// **'Control the camera\'s speaker volume.'**
  String get volumeSettingSubtitle;

  /// Volume off option
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get volumeOff;

  /// Volume low option
  ///
  /// In en, this message translates to:
  /// **'70%'**
  String get volumeLow;

  /// Volume high option
  ///
  /// In en, this message translates to:
  /// **'100%'**
  String get volumeHigh;

  /// Title for upside-down orientation toggle
  ///
  /// In en, this message translates to:
  /// **'Upside-Down Mode'**
  String get orientationUpsideDown;

  /// Subtitle for the upside-down orientation toggle
  ///
  /// In en, this message translates to:
  /// **'Flip the camera image when mounted upside down.'**
  String get orientationUpsideDownSubtitle;

  /// Title for time setting card
  ///
  /// In en, this message translates to:
  /// **'Date & Time'**
  String get timeSetting;

  /// Subtitle for the time setting card
  ///
  /// In en, this message translates to:
  /// **'Sync the camera clock with the current device time.'**
  String get timeSettingSubtitle;

  /// Button label to sync camera time to device time
  ///
  /// In en, this message translates to:
  /// **'Sync to Device Time'**
  String get timeSetToNow;

  /// Label shown next to the camera's current time
  ///
  /// In en, this message translates to:
  /// **'Camera time'**
  String get cameraCurrentTime;

  /// Title for video mode setting card
  ///
  /// In en, this message translates to:
  /// **'Video Mode'**
  String get videoStandardSettingTitle;

  /// Subtitle for video mode setting card
  ///
  /// In en, this message translates to:
  /// **'Switch between NTSC (multiples of 30fps) and PAL (multiples of 25fps) video modes.\nRecommended use is NTSC in North America, Western South America, and Japan. PAL in Europe, Asia, Africa and everywhere else.'**
  String get videoStandardSettingSubtitle;

  /// NTSC video mode option
  ///
  /// In en, this message translates to:
  /// **'NTSC (30fps)'**
  String get videoStandardNtsc;

  /// PAL video mode option
  ///
  /// In en, this message translates to:
  /// **'PAL (25fps)'**
  String get videoStandardPal;

  /// Title for camera information card
  ///
  /// In en, this message translates to:
  /// **'Camera Information'**
  String get cameraInfoTitle;

  /// Label showing the camera model
  ///
  /// In en, this message translates to:
  /// **'Model: {model}'**
  String cameraModel(String model);

  /// Label showing the camera serial number
  ///
  /// In en, this message translates to:
  /// **'Serial number: H{serial}'**
  String cameraSerial(String serial);

  /// Label showing the camera MAC address
  ///
  /// In en, this message translates to:
  /// **'MAC address: {mac}'**
  String cameraMacAddress(String mac);

  /// Label showing the camera firmware version
  ///
  /// In en, this message translates to:
  /// **'Firmware version: {version}'**
  String cameraVersion(String version);

  /// Label showing the camera WiFi information
  ///
  /// In en, this message translates to:
  /// **'WiFi SSID: {ssid}'**
  String cameraWifiSSID(String ssid);

  /// Label showing the camera WiFi password
  ///
  /// In en, this message translates to:
  /// **'WiFi Password: {password}'**
  String cameraWifiPassword(String password);

  /// Title for default camera mode setting card
  ///
  /// In en, this message translates to:
  /// **'Default Camera Mode'**
  String get defaultModeSetting;

  /// Subtitle for default camera mode setting card
  ///
  /// In en, this message translates to:
  /// **'Choose which mode the camera should start in when powered on.'**
  String get defaultModeSettingSubtitle;

  /// Default mode option for video mode
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get defaultModeVideo;

  /// Default mode option for photo mode
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get defaultModePhoto;

  /// Default mode option for time-lapse mode
  ///
  /// In en, this message translates to:
  /// **'Time-Lapse'**
  String get defaultModeTimeLapse;

  /// Default mode option for burst mode
  ///
  /// In en, this message translates to:
  /// **'Burst'**
  String get defaultModeBurst;

  /// Title for locate camera card
  ///
  /// In en, this message translates to:
  /// **'Locate Camera'**
  String get locateCamera;

  /// Subtitle for locate camera card
  ///
  /// In en, this message translates to:
  /// **'Make the camera beep and flash its LEDs to help you find it.'**
  String get locateCameraSubtitle;

  /// Button to start locating the camera
  ///
  /// In en, this message translates to:
  /// **'Start Locating'**
  String get locateCameraButton;

  /// Title of the locate camera dialog
  ///
  /// In en, this message translates to:
  /// **'Locating Camera'**
  String get locateCameraDialogTitle;

  /// Message shown in the locate camera dialog
  ///
  /// In en, this message translates to:
  /// **'The camera is beeping and flashing. Tap Stop when you\'ve found it.'**
  String get locateCameraDialogMessage;

  /// Button to stop locating the camera
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get locateCameraStop;

  /// Title for the disconnect and shut off card in camera settings
  ///
  /// In en, this message translates to:
  /// **'Disconnect & Turn Off'**
  String get disconnectTitle;

  /// Subtitle for the disconnect and shut off card in camera settings
  ///
  /// In en, this message translates to:
  /// **'Turn off the camera and return to the home screen.'**
  String get disconnectSubtitle;

  /// Title of the confirmation dialog before turning off the camera
  ///
  /// In en, this message translates to:
  /// **'Turn Off Camera?'**
  String get disconnectConfirmTitle;

  /// Body text of the confirmation dialog before turning off the camera
  ///
  /// In en, this message translates to:
  /// **'This will power off the camera and disconnect. Any active recording will be stopped.'**
  String get disconnectConfirmMessage;

  /// Message shown when live view cannot be displayed while the camera is in settings mode
  ///
  /// In en, this message translates to:
  /// **'Live view is not available in settings mode.'**
  String get liveViewUnavailableInSettings;

  /// Confirm button label in the turn off camera dialog
  ///
  /// In en, this message translates to:
  /// **'Turn Off'**
  String get disconnectConfirmButton;

  /// Video resolution: WVGA at 240 frames per second
  ///
  /// In en, this message translates to:
  /// **'WVGA 240 fps'**
  String get resolutionWvga240fps;

  /// Video resolution: 720p
  ///
  /// In en, this message translates to:
  /// **'720p'**
  String get resolution720p;

  /// Video resolution: 960p with 4:3 aspect ratio
  ///
  /// In en, this message translates to:
  /// **'960p (4:3)'**
  String get resolution960p;

  /// Video resolution: 1080p
  ///
  /// In en, this message translates to:
  /// **'1080p'**
  String get resolution1080p;

  /// Video resolution: 1440p with 4:3 aspect ratio
  ///
  /// In en, this message translates to:
  /// **'1440p (4:3)'**
  String get resolution1440p;

  /// Video resolution: 2.7K
  ///
  /// In en, this message translates to:
  /// **'2.7K'**
  String get resolution2_7k;

  /// Video resolution: 4K
  ///
  /// In en, this message translates to:
  /// **'4K'**
  String get resolution4k;

  /// Video resolution: 2.7K with 17:9 aspect ratio
  ///
  /// In en, this message translates to:
  /// **'2.7K (17:9)'**
  String get resolution2_7k_17_9;

  /// Video resolution: 4K with 17:9 aspect ratio
  ///
  /// In en, this message translates to:
  /// **'4K (17:9)'**
  String get resolution4k_17_9;

  /// Video resolution: 1080p with SuperView wide angle mode
  ///
  /// In en, this message translates to:
  /// **'1080p SuperView'**
  String get resolution1080pSuperView;

  /// Video resolution: 720p with SuperView wide angle mode
  ///
  /// In en, this message translates to:
  /// **'720p SuperView'**
  String get resolution720pSuperView;

  /// ON button label or toggle state
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get buttonOn;

  /// OFF button label or toggle state
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get buttonOff;

  /// Camera mode: Time-lapse
  ///
  /// In en, this message translates to:
  /// **'Time-Lapse'**
  String get cameraModeTimelapse;

  /// Camera mode: HDMI output
  ///
  /// In en, this message translates to:
  /// **'HDMI Output'**
  String get cameraModeHdmi;

  /// Camera mode: Settings menu
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get cameraModeSettings;

  /// Power state: Off
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get powerOff;

  /// Power state: On
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get powerOn;

  /// Shutter action: Stop recording
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get shutterStop;

  /// Shutter action: Start recording
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get shutterStart;

  /// Preview state: Off
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get previewOff;

  /// Preview state: On
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get previewOn;

  /// Locate function: Off
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get locateOff;

  /// Locate function: On
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get locateOn;

  /// Interval: Every 5 seconds
  ///
  /// In en, this message translates to:
  /// **'Every 5 seconds'**
  String get videoAndPhotoEvery5s;

  /// Interval: Every 10 seconds
  ///
  /// In en, this message translates to:
  /// **'Every 10 seconds'**
  String get videoAndPhotoEvery10s;

  /// Interval: Every 30 seconds
  ///
  /// In en, this message translates to:
  /// **'Every 30 seconds'**
  String get videoAndPhotoEvery30s;

  /// Interval: Every 60 seconds
  ///
  /// In en, this message translates to:
  /// **'Every 60 seconds'**
  String get videoAndPhotoEvery60s;

  /// Loop video duration: 5 minutes
  ///
  /// In en, this message translates to:
  /// **'5 Minutes'**
  String get loopVideo5Min;

  /// Loop video duration: 20 minutes
  ///
  /// In en, this message translates to:
  /// **'20 Minutes'**
  String get loopVideo20Min;

  /// Loop video duration: 1 hour
  ///
  /// In en, this message translates to:
  /// **'1 Hour'**
  String get loopVideo1Hour;

  /// Loop video duration: 2 hours
  ///
  /// In en, this message translates to:
  /// **'2 Hours'**
  String get loopVideo2Hour;

  /// Loop video duration: Use maximum storage
  ///
  /// In en, this message translates to:
  /// **'Max Storage'**
  String get loopVideoMaxStorage;

  /// Photo resolution: 5 megapixels medium
  ///
  /// In en, this message translates to:
  /// **'5MP Medium'**
  String get photoResolution5MpMedium;

  /// Photo resolution: 7 megapixels medium
  ///
  /// In en, this message translates to:
  /// **'7MP Medium'**
  String get photoResolution7MpMedium;

  /// Photo resolution: 7 megapixels wide
  ///
  /// In en, this message translates to:
  /// **'7MP Wide'**
  String get photoResolution7MpWide;

  /// Photo resolution: 12 megapixels wide
  ///
  /// In en, this message translates to:
  /// **'12MP Wide'**
  String get photoResolution12MpWide;

  /// Timelapse interval: 0.5 seconds
  ///
  /// In en, this message translates to:
  /// **'0.5 Seconds'**
  String get timelapse0_5Sec;

  /// Timelapse interval: 1 second
  ///
  /// In en, this message translates to:
  /// **'1 Second'**
  String get timelapse1Sec;

  /// Timelapse interval: 2 seconds
  ///
  /// In en, this message translates to:
  /// **'2 Seconds'**
  String get timelapse2Sec;

  /// Timelapse interval: 5 seconds
  ///
  /// In en, this message translates to:
  /// **'5 Seconds'**
  String get timelapse5Sec;

  /// Timelapse interval: 10 seconds
  ///
  /// In en, this message translates to:
  /// **'10 Seconds'**
  String get timelapse10Sec;

  /// Timelapse interval: 30 seconds
  ///
  /// In en, this message translates to:
  /// **'30 Seconds'**
  String get timelapse30Sec;

  /// Timelapse interval: 60 seconds
  ///
  /// In en, this message translates to:
  /// **'60 Seconds'**
  String get timelapse60Sec;

  /// Continuous shot: 3 photos
  ///
  /// In en, this message translates to:
  /// **'3 Photos'**
  String get continuousShot3Photos;

  /// Continuous shot: 5 photos
  ///
  /// In en, this message translates to:
  /// **'5 Photos'**
  String get continuousShot5Photos;

  /// Continuous shot: 10 photos
  ///
  /// In en, this message translates to:
  /// **'10 Photos'**
  String get continuousShot10Photos;

  /// Burst rate: 3 photos per second
  ///
  /// In en, this message translates to:
  /// **'3 Photos/s'**
  String get burstRate3PerSec;

  /// Burst rate: 5 photos per second
  ///
  /// In en, this message translates to:
  /// **'5 Photos/s'**
  String get burstRate5PerSec;

  /// Burst rate: 10 photos per second
  ///
  /// In en, this message translates to:
  /// **'10 Photos/s'**
  String get burstRate10PerSec;

  /// Burst rate: 10 photos per 2 seconds
  ///
  /// In en, this message translates to:
  /// **'10 Photos/2s'**
  String get burstRate10Per2Sec;

  /// Burst rate: 30 photos per second
  ///
  /// In en, this message translates to:
  /// **'30 Photos/s'**
  String get burstRate30PerSec;

  /// Burst rate: 30 photos per 2 seconds
  ///
  /// In en, this message translates to:
  /// **'30 Photos/2s'**
  String get burstRate30Per2Sec;

  /// Burst rate: 30 photos per 3 seconds
  ///
  /// In en, this message translates to:
  /// **'30 Photos/3s'**
  String get burstRate30Per3Sec;

  /// Pro Tune: Enabled
  ///
  /// In en, this message translates to:
  /// **'Pro Tune On'**
  String get protuneOn;

  /// Pro Tune: Disabled
  ///
  /// In en, this message translates to:
  /// **'Pro Tune Off'**
  String get protuneOff;

  /// White balance: Automatic
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get whiteBalanceAuto;

  /// White balance: 3000K color temperature
  ///
  /// In en, this message translates to:
  /// **'3000K'**
  String get whiteBalance3000K;

  /// White balance: 5500K color temperature
  ///
  /// In en, this message translates to:
  /// **'5500K'**
  String get whiteBalance5500K;

  /// White balance: 6500K color temperature
  ///
  /// In en, this message translates to:
  /// **'6500K'**
  String get whiteBalance6500K;

  /// White balance: Camera RAW
  ///
  /// In en, this message translates to:
  /// **'Cam RAW'**
  String get whiteBalanceCamRaw;

  /// Exposure compensation: +2.0
  ///
  /// In en, this message translates to:
  /// **'+2.0'**
  String get exposureCompensation2Plus;

  /// Exposure compensation: +1.5
  ///
  /// In en, this message translates to:
  /// **'+1.5'**
  String get exposureCompensation1_5Plus;

  /// Exposure compensation: +1.0
  ///
  /// In en, this message translates to:
  /// **'+1.0'**
  String get exposureCompensation1Plus;

  /// Exposure compensation: +0.5
  ///
  /// In en, this message translates to:
  /// **'+0.5'**
  String get exposureCompensation0_5Plus;

  /// Exposure compensation: 0.0
  ///
  /// In en, this message translates to:
  /// **'0.0'**
  String get exposureCompensation0;

  /// Exposure compensation: -0.5
  ///
  /// In en, this message translates to:
  /// **'-0.5'**
  String get exposureCompensation0_5Minus;

  /// Exposure compensation: -1.0
  ///
  /// In en, this message translates to:
  /// **'-1.0'**
  String get exposureCompensation1Minus;

  /// Exposure compensation: -1.5
  ///
  /// In en, this message translates to:
  /// **'-1.5'**
  String get exposureCompensation1_5Minus;

  /// Exposure compensation: -2.0
  ///
  /// In en, this message translates to:
  /// **'-2.0'**
  String get exposureCompensation2Minus;

  /// Sharpness: High
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get sharpnessHigh;

  /// Sharpness: Medium
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get sharpnessMedium;

  /// Sharpness: Low
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get sharpnessLow;

  /// ISO limit: 6400
  ///
  /// In en, this message translates to:
  /// **'ISO 6400'**
  String get isoLimit6400;

  /// ISO limit: 1600
  ///
  /// In en, this message translates to:
  /// **'ISO 1600'**
  String get isoLimit1600;

  /// ISO limit: 400
  ///
  /// In en, this message translates to:
  /// **'ISO 400'**
  String get isoLimit400;

  /// Color profile: GoPro standard colors
  ///
  /// In en, this message translates to:
  /// **'GoPro Color'**
  String get colorProfileGoPro;

  /// Color profile: Flat/neutral colors
  ///
  /// In en, this message translates to:
  /// **'Flat Color'**
  String get colorProfileFlat;

  /// Orientation: Normal/upright
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get orientationUp;

  /// Orientation: Upside down
  ///
  /// In en, this message translates to:
  /// **'Upside Down'**
  String get orientationDown;

  /// Auto power off: Never turn off
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get autoPowerOffNever;

  /// Auto power off: After 1 minute
  ///
  /// In en, this message translates to:
  /// **'After 1 minute'**
  String get autoPowerOff1Min;

  /// Auto power off: After 2 minutes
  ///
  /// In en, this message translates to:
  /// **'After 2 minutes'**
  String get autoPowerOff2Min;

  /// Auto power off: After 5 minutes
  ///
  /// In en, this message translates to:
  /// **'After 5 minutes'**
  String get autoPowerOff5Min;

  /// Low light mode: Enabled
  ///
  /// In en, this message translates to:
  /// **'Low Light: On'**
  String get lowLightOn;

  /// Low light mode: Disabled
  ///
  /// In en, this message translates to:
  /// **'Low Light: Off'**
  String get lowLightOff;

  /// Spot metering: Enabled
  ///
  /// In en, this message translates to:
  /// **'Spot Meter: On'**
  String get spotMeterOn;

  /// Spot metering: Disabled
  ///
  /// In en, this message translates to:
  /// **'Spot Meter: Off'**
  String get spotMeterOff;

  /// Button label to restart the live stream
  ///
  /// In en, this message translates to:
  /// **'Fix Stream'**
  String get fixStream;

  /// Message shown when battery drops to 1% or 0%, triggering auto-disconnect
  ///
  /// In en, this message translates to:
  /// **'Battery critically low. Disconnecting from camera.'**
  String get batteryCriticallyLow;

  /// Frame rate: 12 frames per second
  ///
  /// In en, this message translates to:
  /// **'12 fps'**
  String get fps12;

  /// Frame rate: 12.5 frames per second
  ///
  /// In en, this message translates to:
  /// **'12.5 fps'**
  String get fps12_5;

  /// Frame rate: 15 frames per second
  ///
  /// In en, this message translates to:
  /// **'15 fps'**
  String get fps15;

  /// Frame rate: 24 frames per second
  ///
  /// In en, this message translates to:
  /// **'24 fps'**
  String get fps24;

  /// Frame rate: 25 frames per second
  ///
  /// In en, this message translates to:
  /// **'25 fps'**
  String get fps25;

  /// Frame rate: 30 frames per second
  ///
  /// In en, this message translates to:
  /// **'30 fps'**
  String get fps30;

  /// Frame rate: 48 frames per second
  ///
  /// In en, this message translates to:
  /// **'48 fps'**
  String get fps48;

  /// Frame rate: 50 frames per second
  ///
  /// In en, this message translates to:
  /// **'50 fps'**
  String get fps50;

  /// Frame rate: 60 frames per second
  ///
  /// In en, this message translates to:
  /// **'60 fps'**
  String get fps60;

  /// Frame rate: 100 frames per second
  ///
  /// In en, this message translates to:
  /// **'100 fps'**
  String get fps100;

  /// Frame rate: 120 frames per second
  ///
  /// In en, this message translates to:
  /// **'120 fps'**
  String get fps120;

  /// Frame rate: 240 frames per second
  ///
  /// In en, this message translates to:
  /// **'240 fps'**
  String get fps240;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
