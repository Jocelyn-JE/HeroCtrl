import 'dart:async';

import 'package:flutter/material.dart';
import 'package:heroctrl/utils/snackbar.dart';
import 'package:heroctrl/services/gopro_wifi_scanner.dart';
import 'package:heroctrl/widgets/polling_timer_indicator.dart';
import 'package:heroctrl/l10n/app_localizations.dart';
import 'package:wifi_scan/wifi_scan.dart';
import 'widgets/camera_list.dart';
import 'widgets/empty_camera_state.dart';

class CameraSearchScreen extends StatefulWidget {
  const CameraSearchScreen({super.key});

  @override
  State<CameraSearchScreen> createState() => _CameraSearchScreenState();
}

class _CameraSearchScreenState extends State<CameraSearchScreen> {
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
    _apSub = GoProWifiScanner.onResults.listen((_) {
      if (!mounted) return;
      setState(() {});
    });
    _startPeriodicSearch();
  }

  /*
  ** Starts a periodic background search every 30 seconds.
  ** Android WiFi scanning is throttled to 4 scans every 2 minutes per app.
  */
  void _startPeriodicSearch() {
    _pollTimer?.cancel();
    if (!_backgroundSearchInProgress) {
      _backgroundSearchInProgress = true;
      _searchForCameras().whenComplete(() {
        // Update state only if still mounted.
        if (mounted) {
          _backgroundSearchInProgress = false;
          _nextPollNotifier.value = DateTime.now().add(
            Duration(seconds: _pollIntervalSeconds),
          );
        } else {
          _backgroundSearchInProgress = false;
        }
      });
    }
    _pollTimer = Timer.periodic(Duration(seconds: _pollIntervalSeconds), (
      timer,
    ) async {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_backgroundSearchInProgress) return;
      _backgroundSearchInProgress = true;
      await _searchForCameras();
      _backgroundSearchInProgress = false;
      _nextPollNotifier.value = DateTime.now().add(
        Duration(seconds: _pollIntervalSeconds),
      );
    });
  }

  Future<void> _searchForCameras() async {
    try {
      final result = await GoProWifiScanner.startScan();
      if (!result) throw Exception('WiFi scan failed.');
    } catch (e) {
      if (mounted) showSnackBarError(context, '$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.addCamera),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(l10n.aboutPeriodicScanning),
                      content: Text(l10n.periodicScanningInfo),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(l10n.ok),
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
        child: GoProWifiScanner.accessPoints.isNotEmpty
            ? CameraList(accessPoints: GoProWifiScanner.accessPoints)
            : const EmptyCameraState(),
      ),
    );
  }

  @override
  void dispose() {
    _apSub?.cancel();
    GoProWifiScanner.reset();
    _pollTimer?.cancel();
    _nextPollNotifier.dispose();
    super.dispose();
  }
}
