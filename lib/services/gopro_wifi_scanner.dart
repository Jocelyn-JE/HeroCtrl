import 'dart:async';

import 'package:heroctrl/utils/gopro_validator.dart';
import 'package:wifi_scan/wifi_scan.dart';

/// Service for scanning and discovering GoPro cameras on WiFi networks
///
/// This is a singleton class with static methods for easy access.
class GoProWifiScanner {
  // Private constructor to prevent instantiation
  GoProWifiScanner._();

  static final WiFiScan _wifiScan = WiFiScan.instance;

  static StreamSubscription<List<WiFiAccessPoint>>? _subscription;
  static bool _isScanning = false;
  static List<WiFiAccessPoint> _accessPoints = [];

  // add a broadcast stream so UI can listen
  static final StreamController<List<WiFiAccessPoint>> _controller =
      StreamController<List<WiFiAccessPoint>>.broadcast();

  static Stream<List<WiFiAccessPoint>> get onResults => _controller.stream;
  static List<WiFiAccessPoint> get accessPoints => _accessPoints;

  // filter scan results to only include GoPro devices that are not yet registered
  static Future<List<WiFiAccessPoint>> _filterScanResults(
    List<WiFiAccessPoint> apList,
  ) async {
    final filtered = <WiFiAccessPoint>[];
    for (final ap in apList) {
      if (!GoProValidator.isGoPro(ap.bssid) ||
          await GoProValidator.isRegistered(ap.bssid)) {
        continue;
      }
      filtered.add(ap);
    }
    return filtered;
  }

  static Future<bool> startScan() async {
    if (_isScanning) throw Exception('WiFi scan already in progress.');
    final can = await _wifiScan.canStartScan();
    switch (can) {
      case CanStartScan.yes:
        await startListeningToScannedResults();
        _isScanning = true;
        final result = await _wifiScan.startScan();
        _isScanning = false;
        return result;
      case CanStartScan.noLocationPermissionDenied:
        throw Exception('Location permission denied, cannot start WiFi scan.');
      case CanStartScan.noLocationServiceDisabled:
        throw Exception('Location services disabled, cannot start WiFi scan.');
      case CanStartScan.noLocationPermissionRequired:
        throw Exception(
          'Location permission required, cannot start WiFi scan.',
        );
      case CanStartScan.noLocationPermissionUpgradeAccuracy:
        throw Exception(
          'Location permission accuracy upgrade required, cannot start WiFi scan.',
        );
      case CanStartScan.failed:
        throw Exception('Failed to start WiFi scan, check permissions.');
      case CanStartScan.notSupported:
        throw Exception('WiFi scanning not supported on this platform.');
    }
  }

  static Future<void> startListeningToScannedResults() async {
    if (_subscription != null) return; // already listening
    final can = await WiFiScan.instance.canGetScannedResults();
    switch (can) {
      case CanGetScannedResults.yes:
        _subscription = WiFiScan.instance.onScannedResultsAvailable.listen((
          results,
        ) async {
          final filtered = await _filterScanResults(results);
          _accessPoints = filtered;
          _controller.add(filtered);
        });
        break;
      case CanGetScannedResults.noLocationPermissionDenied:
        throw Exception(
          'Location permission denied, cannot get WiFi scan results.',
        );
      case CanGetScannedResults.noLocationServiceDisabled:
        throw Exception(
          'Location services disabled, cannot get WiFi scan results.',
        );
      case CanGetScannedResults.noLocationPermissionRequired:
        throw Exception(
          'Location permission required, cannot get WiFi scan results.',
        );
      case CanGetScannedResults.noLocationPermissionUpgradeAccuracy:
        throw Exception(
          'Location permission accuracy upgrade required, cannot get WiFi scan results.',
        );
      case CanGetScannedResults.notSupported:
        throw Exception('WiFi scanning not supported on this platform.');
    }
  }

  /// Reset the scanner state (cancel subscriptions, clear access points)
  /// Use this when navigating away from the scan screen
  static void reset() {
    _subscription?.cancel();
    _subscription = null;
    _accessPoints = [];
    _isScanning = false;
  }

  /// Dispose resources - should only be called when the app is shutting down
  /// For normal cleanup, use reset() instead
  static void dispose() {
    _subscription?.cancel();
    _controller.close();
  }
}
