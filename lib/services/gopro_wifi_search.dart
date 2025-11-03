import 'dart:async';

import 'package:wifi_scan/wifi_scan.dart';

/*
** OUI standard license header for GoPro, Inc.
** D8:96:85 2011-08-05 HERO2 / HERO3 / HERO3+
** D4:D9:19 2013-09-12 HERO4 / HERO4 Silver
** F4:DD:9E 2014-04-22 HERO4 Black / HERO5
** 04:41:69 2015-11-17 HERO5 Session ou Black
** D4:32:60 2018-07-28 HERO6 / HERO7
** 24:74:F7 2019-08-07 HERO7 / HERO8
** 04:57:47 2022-05-07 HERO9 / HERO10
** AC:04:AA 2024-09-04 HERO10 / HERO11 or newer
** I have NO idea if this is true, to be honest I just asked ChatGPT
** about the OUI prefixes with their release dates and it gave me these.
** So take this with a grain of salt.
*/

class GoProWifiSearch {
  final WiFiScan _wifiScan = WiFiScan.instance;

  StreamSubscription<List<WiFiAccessPoint>>? _subscription;
  bool _isScanning = false;
  List<WiFiAccessPoint> accessPoints = [];

  // add a broadcast stream so UI can listen
  final StreamController<List<WiFiAccessPoint>> _controller =
      StreamController<List<WiFiAccessPoint>>.broadcast();

  Stream<List<WiFiAccessPoint>> get onResults => _controller.stream;

  /*
  ** Check if a given BSSID belongs to a GoPro device based on known OUI prefixes.
  ** Since the app is made with only a GoPro Hero 3+ available to test, this
  ** function may need to be updated in the future if we need to add support for
  ** newer GoPro models with different OUI prefixes.
  */
  bool isGoPro(String bssid) {
    const prefixes = ['D8:96:85'];
    return prefixes.any((p) => bssid.toUpperCase().startsWith(p));
  }

  Future<bool> startScan() async {
    bool result;

    if (_isScanning) throw Exception('WiFi scan already in progress.');
    final can = await _wifiScan.canStartScan(askPermissions: true);
    switch (can) {
      case CanStartScan.yes:
        _isScanning = true;
        result = await _wifiScan.startScan();
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

  List<WiFiAccessPoint> _filterScanResults(List<WiFiAccessPoint> apList) {
    return apList.where((ap) => isGoPro(ap.bssid)).toList();
  }

  void startListeningToScannedResults() async {
    final can = await WiFiScan.instance.canGetScannedResults(
      askPermissions: true,
    );
    switch (can) {
      case CanGetScannedResults.yes:
        _subscription = WiFiScan.instance.onScannedResultsAvailable.listen((
          results,
        ) {
          accessPoints = _filterScanResults(results);
          // push new results to listeners
          _controller.add(accessPoints);
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

  void dispose() {
    _subscription?.cancel();
    _controller.close();
  }
}
