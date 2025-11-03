import 'dart:async';

import 'package:flutter/material.dart';
import 'package:heroctrl/services/gopro_wifi_search.dart';
import 'package:wifi_scan/wifi_scan.dart';

class CameraSearchScreen extends StatefulWidget {
  const CameraSearchScreen({super.key});

  @override
  State<CameraSearchScreen> createState() => _CameraSearchScreenState();
}

class _CameraSearchScreenState extends State<CameraSearchScreen> {
  final GoProWifiSearch _wifiSearch = GoProWifiSearch();
  bool isSearching = true;

  StreamSubscription<List<WiFiAccessPoint>>? _apSub;

  // added: periodic timer + background guard
  Timer? _pollTimer;
  bool _backgroundSearchInProgress = false;

  @override
  void initState() {
    super.initState();
    _wifiSearch.startListeningToScannedResults();
    // listen and rebuild when new access points arrive
    _apSub = _wifiSearch.onResults.listen((_) {
      if (mounted) setState(() {});
    });
    _searchForCameras();
    _startPeriodicSearch(); // start periodic background polling
  }

  @override
  void dispose() {
    _pollTimer?.cancel(); // cancel periodic polling
    _apSub?.cancel();
    _wifiSearch.dispose();
    super.dispose();
  }

  // added: start periodic background searches every 5 seconds
  void _startPeriodicSearch() {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_backgroundSearchInProgress) return; // avoid overlap
      _backgroundSearchInProgress = true;
      try {
        await _searchForCameras(showProgress: false);
      } finally {
        _backgroundSearchInProgress = false;
      }
    });
  }

  void _showSnackBar(String message, {Color? color}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }

  Future<void> _searchForCameras({bool showProgress = true}) async {
    if (showProgress) {
      setState(() {
        isSearching = true;
      });
    }
    try {
      // Start WiFi scan
      await _wifiSearch.startScan();
      await Future.delayed(const Duration(seconds: 2));
      // Get the latest scan results
      if (_wifiSearch.accessPoints.isNotEmpty && showProgress) {
        _showSnackBar(
          'Found ${_wifiSearch.accessPoints.length} camera(s)',
          color: Colors.green,
        );
      }
    } catch (e) {
      if (showProgress) _showSnackBar('$e', color: Colors.red);
    } finally {
      if (showProgress) {
        setState(() {
          isSearching = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add a camera')),
      body: Center(
        child: isSearching
            ? _buildSearching()
            : (_wifiSearch.accessPoints.isNotEmpty
                  ? _buildListView()
                  : _buildEmpty()),
      ),
    );
  }

  Widget _buildSearching() {
    final double bottomInset = MediaQuery.of(context).padding.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(8, 0, 8, bottomInset),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Searching for cameras...'),
        ],
      ),
    );
  }

  Widget _buildListView() {
    final double bottomInset = MediaQuery.of(context).padding.bottom;
    return RefreshIndicator(
      onRefresh: _searchForCameras,
      child: ListView.builder(
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
      ),
    );
  }

  Widget _buildEmpty() {
    final double bottomInset = MediaQuery.of(context).padding.bottom;
    return RefreshIndicator(
      onRefresh: _searchForCameras,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
            children: [
              SizedBox(
                height: constraints.maxHeight - bottomInset,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 32,
                      child: Icon(Icons.videocam_off, size: 32),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No cameras found.\nPull down to refresh.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
