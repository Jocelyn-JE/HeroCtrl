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
  String get videoModeSettingTitle;

  /// Subtitle for video mode setting card
  ///
  /// In en, this message translates to:
  /// **'Switch between NTSC (multiples of 30fps) and PAL (multiples of 25fps) video modes.'**
  String get videoModeSettingSubtitle;

  /// NTSC video mode option
  ///
  /// In en, this message translates to:
  /// **'NTSC (30fps)'**
  String get videoModeNtsc;

  /// PAL video mode option
  ///
  /// In en, this message translates to:
  /// **'PAL (25fps)'**
  String get videoModePal;
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
