import 'package:flutter/material.dart';
import 'package:heroctrl/models/camera_state.dart';
import 'package:heroctrl/screens/control_screen/battery_monitor.dart';
import 'package:heroctrl/screens/control_screen/widgets/battery_indicator.dart';
import 'package:heroctrl/screens/control_screen/widgets/live_view.dart';
import 'package:heroctrl/services/app_prefs.dart';
import 'package:heroctrl/services/gopro_connection_service.dart';
import 'package:heroctrl/services/gopro_api_service.dart';
import 'package:heroctrl/utils/logger.dart';
import 'package:heroctrl/utils/snackbar.dart';

class ControlScreen extends StatefulWidget {
  const ControlScreen({super.key});

  @override
  State<ControlScreen> createState() => _RegisterControlScreenState();
}

class _RegisterControlScreenState extends State<ControlScreen> {
  final _password = GoProConnectionService.currentConnection!.password;
  CameraState? _cameraState;
  BatteryMonitor? _batteryMonitor;

  @override
  void initState() {
    super.initState();
    AppLogger.info('ControlScreen: initState called');
    _fetchCameraState();
  }

  Future<void> _fetchCameraState() async {
    try {
      AppLogger.info('Waiting for camera to power on...');
      await GoProApiService.waitUntilCameraOn(_password);
      final state = await GoProApiService.getStatus(_password);
      final batteryPercent = await GoProApiService.getBatteryLevel(_password);
      if (mounted) {
        final monitor = BatteryMonitor(
          camPassword: _password,
          initialPercent: batteryPercent,
        );
        monitor.batteryPercent.addListener(_onBatteryChanged);
        monitor.estimatedMinutesRemaining.addListener(_onBatteryChanged);
        setState(() {
          _cameraState = CameraState(state);
          _cameraState!.isCameraOn = true;
          _batteryMonitor = monitor;
        });
        await _checkPreviewStatus();
        monitor.start();
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching camera state', e, stackTrace);
      if (mounted) {
        showSnackBar(
          context,
          'Error fetching camera state: $e',
          color: Colors.red,
        );
      }
    }
  }

  void _onBatteryChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _checkPreviewStatus() async {
    try {
      AppLogger.info('Camera is on, waiting for preview to be enabled...');
      await GoProApiService.waitUntilPreviewOn(_password);
      AppLogger.info('Preview status: ON');
      if (mounted) {
        setState(() {
          _cameraState?.isPreviewOn = true;
        });
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error checking preview status', e, stackTrace);
      if (mounted) {
        showSnackBar(context, 'Error: $e', color: Colors.red);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(GoProConnectionService.currentConnection!.ssid),
        actions: [
          if (_batteryMonitor != null)
            BatteryIndicator(
              batteryPercent: _batteryMonitor!.batteryPercent.value,
              estimatedMinutesRemaining:
                  _batteryMonitor!.estimatedMinutesRemaining.value,
            ),
          if (_cameraState?.isCameraOn == true)
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () async {
                await Navigator.pushNamed(context, '/camera_settings');
              },
            ),
        ],
      ),
      body: SafeArea(
        bottom: true,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_cameraState?.isPreviewOn == true)
                LiveView(camPassword: _password)
              else
                const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() async {
    _batteryMonitor?.batteryPercent.removeListener(_onBatteryChanged);
    _batteryMonitor?.estimatedMinutesRemaining.removeListener(
      _onBatteryChanged,
    );
    _batteryMonitor?.dispose();
    if (await AppPrefs.getSwitchOffCameraOnDisconnect()) {
      try {
        await GoProApiService.turnOffCamera(_password);
      } catch (e, stackTrace) {
        AppLogger.error(
          'Error turning off camera on disconnect',
          e,
          stackTrace,
        );
      }
    }
    GoProConnectionService.disconnect(instant: true);
    super.dispose();
  }
}
