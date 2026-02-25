import 'package:heroctrl/models/gopro_registration.dart';
import 'package:heroctrl/services/gopro_api_service.dart';
import 'package:heroctrl/services/gopro_prefs.dart';
import 'package:heroctrl/utils/gopro_validator.dart';
import 'package:wifi_iot/wifi_iot.dart';

/// Service for connecting to and registering GoPro cameras
class GoProConnectionService {
  GoProConnectionService._();

  static GoProRegistration? currentConnection;

  /// Connect to an unregistered GoPro camera
  static Future<bool> connectToUnregisteredGoPro(
    String ssid,
    String bssid,
    String password,
  ) async {
    final bool connected = await WiFiForIoTPlugin.connect(
      ssid,
      bssid: bssid,
      password: password,
      security: NetworkSecurity.WPA,
      timeoutInSeconds: 10,
    );
    WiFiForIoTPlugin.forceWifiUsage(true);
    return connected;
  }

  /// Connect to a registered GoPro camera
  static Future<bool> connectToRegisteredGoPro(
    GoProRegistration registration,
  ) async {
    final bool connected = await connectToUnregisteredGoPro(
      registration.ssid,
      registration.bssid,
      registration.password,
    );
    if (connected) currentConnection = registration;
    return connected;
  }

  /// Disconnect from the current WiFi network
  static Future<void> disconnect() async {
    currentConnection = null;
    WiFiForIoTPlugin.forceWifiUsage(false);
    WiFiForIoTPlugin.disconnect();
  }

  /// Connect to a GoPro camera, retrieve its information, and register it
  ///
  /// This method orchestrates the entire registration process:
  /// 1. Validates the camera is a GoPro and not already registered
  /// 2. Connects to the camera's WiFi network
  /// 3. Powers on the camera and retrieves device information via API
  /// 4. Stores the camera registration
  /// 5. Powers off and disconnects from the camera
  static Future<bool> connectAndStore(
    String ssid,
    String bssid,
    String password,
  ) async {
    if (!GoProValidator.isGoPro(bssid)) {
      throw Exception('The specified BSSID does not belong to a GoPro device.');
    }
    if (await GoProValidator.isRegistered(bssid)) {
      throw Exception('This GoPro device is already registered.');
    }
    if (!await connectToUnregisteredGoPro(ssid, bssid, password)) return false;

    // Get serial number, MAC address, camera model and firmware version
    // from the GoPro device via its API
    // Give the WiFi connection time to stabilize on mobile
    await Future.delayed(const Duration(seconds: 3));
    await GoProApiService.turnOnCamera(password);
    // Small delay to let camera turn on
    await Future.delayed(const Duration(seconds: 5));
    final version = await GoProApiService.getVersion(password);
    final serialAndMac = await GoProApiService.getSerialAndMacAddress(password);
    final registration = GoProRegistration(
      ssid: ssid,
      bssid: bssid,
      serialNumber: 'H${serialAndMac.serialNumber}',
      cameraModel: version.cameraType,
      firmwareVersion: version.firmwareVersion,
      macAddress: serialAndMac.macAddress,
      password: password,
    );
    await GoProPrefs.add(registration);

    // Clean up WiFi connection
    await Future.delayed(const Duration(seconds: 3));
    await GoProApiService.turnOffCamera(password);
    await Future.delayed(const Duration(milliseconds: 500));
    disconnect();
    return true;
  }
}
