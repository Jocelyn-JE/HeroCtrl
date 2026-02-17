import 'dart:async';

import 'package:flutter/material.dart';
import 'package:heroctrl/utils/logger.dart';
import 'package:heroctrl/utils/snackbar.dart';
import 'package:heroctrl/services/gopro_wifi_search.dart';
import 'package:heroctrl/widgets/password_field.dart';
import 'package:wifi_scan/wifi_scan.dart';
import 'package:heroctrl/widgets/polling_timer_indicator.dart';
import 'package:heroctrl/l10n/app_localizations.dart';

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
      final result = await _wifiSearch.startScan();
      if (!result) throw Exception('WiFi scan failed.');
    } catch (e) {
      if (mounted) showSnackBar(context, '$e', color: Colors.red);
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
        child: _wifiSearch.accessPoints.isNotEmpty
            ? _buildListView()
            : _buildEmpty(),
      ),
    );
  }

  Widget _buildConnectionDialog(String ssid, String bssid) {
    final localizations = AppLocalizations.of(context)!;
    final controller = TextEditingController();
    final navigator = Navigator.of(context);
    bool isLoading = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          title: Text(localizations.connectToCamera(ssid)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isLoading) ...[
                const CircularProgressIndicator(),
                const SizedBox(height: 8),
                Text(
                  localizations.connectingToCamera,
                  textAlign: TextAlign.center,
                ),
              ] else ...[
                PasswordField(controller: controller),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: isLoading
                  ? null
                  : () => Navigator.of(context).pop(false),
              child: Text(localizations.cancel),
            ),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      final messenger = ScaffoldMessenger.of(context);
                      setState(() => isLoading = true);
                      bool result = false;
                      try {
                        result = await _wifiSearch.connectAndStore(
                          ssid,
                          bssid,
                          controller.text,
                        );
                      } catch (e) {
                        if (!mounted) return;
                        messenger.showSnackBar(
                          SnackBar(
                            content: Text(
                              localizations.connectionError(e.toString()),
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                        AppLogger.error('Error connecting to $ssid: $e');
                        setState(() => isLoading = false);
                        return navigator.pop(result);
                      }
                      if (result != true) {
                        if (!mounted) return;
                        messenger.showSnackBar(
                          SnackBar(
                            content: Text(localizations.connectionFailed(ssid)),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                      navigator.pop(result);
                    },
              child: isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(localizations.connect),
            ),
          ],
        );
      },
    );
  }

  Widget _buildListView() {
    final localizations = AppLocalizations.of(context)!;
    final double bottomInset = MediaQuery.of(context).padding.bottom;
    ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(8, 0, 8, bottomInset),
      itemCount: _wifiSearch.accessPoints.length,
      itemBuilder: (context, index) {
        final ssid = _wifiSearch.accessPoints[index].ssid;
        final bssid = _wifiSearch.accessPoints[index].bssid;
        return Card(
          child: ListTile(
            leading: CircleAvatar(child: Icon(Icons.videocam)),
            trailing: Icon(Icons.chevron_right),
            title: Text(ssid),
            subtitle: Text(localizations.bssidLabel(bssid)),
            onTap: () async {
              final navigator = Navigator.of(context);
              final connected = await showDialog<bool>(
                context: context,
                builder: (context) => _buildConnectionDialog(ssid, bssid),
              );
              if (connected != true) return;
              navigator.popUntil((route) => route.isFirst);
              scaffoldMessenger.clearSnackBars();
            },
          ),
        );
      },
    );
  }

  Widget _buildEmpty() {
    final localizations = AppLocalizations.of(context)!;
    final double bottomInset = MediaQuery.of(context).padding.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(8, 0, 8, bottomInset),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(radius: 32, child: Icon(Icons.videocam_off, size: 32)),
            SizedBox(height: 16),
            Text(localizations.noCamerasFound, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _apSub?.cancel();
    _wifiSearch.dispose();
    _pollTimer?.cancel();
    _nextPollNotifier.dispose();
    super.dispose();
  }
}
