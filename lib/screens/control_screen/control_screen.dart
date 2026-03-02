import 'package:flutter/material.dart';
import 'package:heroctrl/constants/gopro_endpoints.dart';
import 'package:heroctrl/models/camera_state.dart';
import 'package:heroctrl/screens/control_screen/battery_monitor.dart';
import 'package:heroctrl/screens/control_screen/widgets/battery_indicator.dart';
import 'package:heroctrl/screens/control_screen/widgets/live_view.dart';
import 'package:heroctrl/screens/control_screen/widgets/resolution_selector.dart';
import 'package:heroctrl/services/app_prefs.dart';
import 'package:heroctrl/services/gopro_connection_service.dart';
import 'package:heroctrl/services/gopro_api_service.dart';
import 'package:heroctrl/utils/app_routes.dart';
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
  bool _isAutoDisconnectingForLowBattery = false;

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
        _checkLowBatteryAndDisconnect();
        await _checkPreviewStatus();
        monitor.start();
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching camera state', e, stackTrace);
      if (mounted) {
        showSnackBarError(context, 'Error fetching camera state: $e');
      }
    }
  }

  void _onBatteryChanged() {
    if (mounted) setState(() {});
    _checkLowBatteryAndDisconnect();
  }

  void _checkLowBatteryAndDisconnect() {
    final batteryPercent = _batteryMonitor?.batteryPercent.value;
    if (!mounted ||
        _isAutoDisconnectingForLowBattery ||
        batteryPercent == null) {
      return;
    }

    if (batteryPercent <= 1) {
      _isAutoDisconnectingForLowBattery = true;
      showSnackBarWarning(
        context,
        'Battery critically low. Disconnecting from camera.',
      );
      Navigator.of(context).popUntil(ModalRoute.withName(AppRoutes.home));
    }
  }

  Future<void> _onResolutionChanged(VideoResolution newResolution) async {
    try {
      await GoProApiService.setVideoResolution(_password, newResolution);
      // Refresh camera status to get the updated resolution
      final updatedStatus = await GoProApiService.getStatus(_password);
      if (mounted) {
        setState(() {
          _cameraState!.status = updatedStatus;
        });
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error changing video resolution', e, stackTrace);
      if (mounted) {
        showSnackBarError(context, 'Error changing resolution: $e');
      }
    }
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
        showSnackBarError(context, 'Error: $e');
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
              if (_cameraState != null)
                ResolutionSelector(
                  cameraState: _cameraState!,
                  password: _password,
                  onResolutionChanged: _onResolutionChanged,
                ),
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
