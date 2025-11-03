import 'dart:async';

import 'package:flutter/material.dart';
import 'package:heroctrl/core/utils/snackbar.dart';
import 'package:heroctrl/services/gopro_wifi_search.dart';
import 'package:wifi_scan/wifi_scan.dart';
import 'package:heroctrl/widgets/polling_timer_indicator.dart';

class CameraSearchScreen extends StatefulWidget {
  const CameraSearchScreen({super.key});

  @override
  State<CameraSearchScreen> createState() => _CameraSearchScreenState();
}

class _CameraSearchScreenState extends State<CameraSearchScreen> {
  final GoProWifiSearch _wifiSearch = GoProWifiSearch();

  // Subscription to access point results, updates UI when new results arrive
  StreamSubscription<List<WiFiAccessPoint>>? _apSub;

  // added: periodic timer + background guard
  Timer? _pollTimer;
  bool _backgroundSearchInProgress = false;
  final int _pollIntervalSeconds = 30;
  final ValueNotifier<DateTime?> _nextPollNotifier = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    _apSub = _wifiSearch.onResults.listen((_) {
      if (!mounted) return;
      setState(() {});
      if (_wifiSearch.accessPoints.isNotEmpty) {
        showSnackBar(
          context,
          'Found ${_wifiSearch.accessPoints.length} camera(s)',
          color: Colors.green,
        );
      }
    });
    _requestPermissionsAndStartSearch();
  }

  Future<void> _requestPermissionsAndStartSearch() async {
    try {
      // Skip canStartScan() check — it has a bug with location on Android 16
      // Just try to start listening and scanning directly
      await _wifiSearch.startListeningToScannedResults();
      _startPeriodicSearch();
    } catch (e) {
      if (mounted) showSnackBar(context, '$e', color: Colors.red);
    }
  }

  @override
  void dispose() {
    _apSub?.cancel();
    _wifiSearch.dispose();
    _pollTimer?.cancel();
    _nextPollNotifier.dispose();
    super.dispose();
  }

  /*
  ** Starts a periodic background search every 30 seconds.
  ** Android WiFi scanning is throttled to 4 scans every 2 minutes per app.
  */
  void _startPeriodicSearch() {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(Duration(seconds: _pollIntervalSeconds), (
      timer,
    ) async {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_backgroundSearchInProgress) return;
      _backgroundSearchInProgress = true;
      try {
        await _searchForCameras();
      } finally {
        _backgroundSearchInProgress = false;
        _nextPollNotifier.value = DateTime.now().add(
          Duration(seconds: _pollIntervalSeconds),
        );
      }
    });
  }

  Future<void> _searchForCameras() async {
    try {
      await _wifiSearch.startScan();
    } catch (e) {
      if (mounted) showSnackBar(context, '$e', color: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a camera'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('About periodic scanning'),
                      content: const Text(
                        'The timer indicates when the next automatic scan will occur. '
                        'WiFi scanning is limited by Android to 4 scans every 2 minutes per app. ',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: ValueListenableBuilder<DateTime?>(
                valueListenable: _nextPollNotifier,
                builder: (context, nextPoll, _) {
                  final next =
                      nextPoll ??
                      DateTime.now().add(
                        Duration(seconds: _pollIntervalSeconds),
                      );
                  return PollingTimerIndicator(
                    nextPollTime: next,
                    pollIntervalSeconds: _pollIntervalSeconds,
                    size: 20,
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: _wifiSearch.accessPoints.isNotEmpty
            ? _buildListView()
            : _buildEmpty(),
      ),
    );
  }

  Widget _buildListView() {
    final double bottomInset = MediaQuery.of(context).padding.bottom;
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(8, 0, 8, bottomInset),
      itemCount: _wifiSearch.accessPoints.length,
      itemBuilder: (context, index) {
        final title = _wifiSearch.accessPoints[index].ssid;
        final bssid = _wifiSearch.accessPoints[index].bssid;
        return Card(
          child: ListTile(
            leading: CircleAvatar(child: Icon(Icons.videocam)),
            title: Text(title),
            subtitle: Text('BSSID: $bssid'),
            onTap: () {
              // handle tap
            },
          ),
        );
      },
    );
  }

  Widget _buildEmpty() {
    final double bottomInset = MediaQuery.of(context).padding.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(8, 0, 8, bottomInset),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(radius: 32, child: Icon(Icons.videocam_off, size: 32)),
            SizedBox(height: 16),
            Text('No cameras found.', textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
