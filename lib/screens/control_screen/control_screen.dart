import 'dart:async';

import 'package:flutter/material.dart';
import 'package:heroctrl/constants/gopro_action_enums.dart';
import 'package:heroctrl/constants/gopro_recording_enums.dart';
import 'package:heroctrl/models/camera_state.dart';
import 'package:heroctrl/screens/control_screen/battery_monitor.dart';
import 'package:heroctrl/screens/control_screen/widgets/battery_indicator.dart';
import 'package:heroctrl/screens/control_screen/widgets/live_view.dart';
import 'package:heroctrl/screens/control_screen/widgets/record_button.dart';
import 'package:heroctrl/screens/control_screen/widgets/resolution_selector.dart';
import 'package:heroctrl/screens/control_screen/widgets/fps_selector.dart';
import 'package:heroctrl/screens/control_screen/widgets/fov_selector.dart';
import 'package:heroctrl/services/app_prefs.dart';
import 'package:heroctrl/services/gopro_connection_service.dart';
import 'package:heroctrl/services/gopro_api_service.dart';
import 'package:heroctrl/l10n/app_localizations.dart';
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
      final localizations = AppLocalizations.of(context)!;
      showSnackBarWarning(context, localizations.batteryCriticallyLow);
      Navigator.of(context).popUntil(ModalRoute.withName(AppRoutes.home));
    }
  }

  Future<void> _onResolutionChanged(VideoResolution newResolution) async {
    try {
      await GoProApiService.setVideoResolution(_password, newResolution);
      // Refresh camera status to get the updated resolution and available FPS
      await _updateCameraStatus();
    } catch (e, stackTrace) {
      AppLogger.error('Error changing video resolution', e, stackTrace);
      if (mounted) {
        showSnackBarError(context, 'Error changing resolution: $e');
      }
    }
  }

  Future<void> _onFpsChanged(FPS newFps) async {
    try {
      await GoProApiService.setFPS(_password, newFps);
      // Refresh camera status to get the updated FPS
      await _updateCameraStatus();
    } catch (e, stackTrace) {
      AppLogger.error('Error changing FPS', e, stackTrace);
      if (mounted) {
        showSnackBarError(context, 'Error changing FPS: $e');
      }
    }
  }

  Future<void> _onFovChanged(FOV newFov) async {
    try {
      await GoProApiService.setFOV(_password, newFov);
      // Refresh camera status to get the updated FOV
      await _updateCameraStatus();
    } catch (e, stackTrace) {
      AppLogger.error('Error changing FOV', e, stackTrace);
      if (mounted) {
        showSnackBarError(context, 'Error changing FOV: $e');
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

  Future<void> _updateCameraStatus() async {
    final updatedStatus = await GoProApiService.getStatus(_password);
    if (mounted && _cameraState != null) {
      setState(() {
        _cameraState!.status = updatedStatus;
      });
    }
  }

  Future<void> _refreshCameraStatus() async {
    try {
      await _updateCameraStatus();
    } catch (e, stackTrace) {
      AppLogger.error('Error refreshing camera status', e, stackTrace);
    }
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;

    final Widget previewArea;
    if (_cameraState?.isPreviewOn == true &&
        _cameraState?.isCameraOn == true &&
        _cameraState?.status.cameraMode != CameraMode.settings) {
      previewArea = LiveView(
        camPassword: _password,
        isRecording: _cameraState!.status.shutterStatus,
        currentResolution: _cameraState!.status.videoResolution,
      );
    } else if (_cameraState?.status.cameraMode == CameraMode.settings) {
      previewArea = Text(
        AppLocalizations.of(context)!.liveViewUnavailableInSettings,
      );
    } else {
      previewArea = const CircularProgressIndicator();
    }

    final content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child:
              _cameraState?.isPreviewOn == true &&
                  _cameraState?.isCameraOn == true &&
                  _cameraState?.status.cameraMode != CameraMode.settings
              ? previewArea
              : Center(child: previewArea),
        ),
        if (_cameraState != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ResolutionSelector(
                    cameraState: _cameraState!,
                    password: _password,
                    onResolutionChanged: _onResolutionChanged,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FPSSelector(
                    cameraState: _cameraState!,
                    password: _password,
                    onFpsChanged: _onFpsChanged,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FOVSelector(
                    cameraState: _cameraState!,
                    password: _password,
                    onFovChanged: _onFovChanged,
                  ),
                ),
              ),
            ],
          ),
      ],
    );

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
                // Refresh camera status in case settings like video mode changed the FPS
                await _refreshCameraStatus();
              },
            ),
        ],
      ),
      body: SafeArea(
        left: false,
        right: false,
        top: false,
        child: Center(child: content),
      ),
      floatingActionButtonLocation: orientation == Orientation.landscape
          ? FloatingActionButtonLocation.miniEndFloat
          : FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _cameraState != null
          ? Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: RecordButton(
                cameraState: _cameraState!,
                password: _password,
                onStatusUpdated: _updateCameraStatus,
              ),
            )
          : null,
    );
  }

  @override
  void dispose() {
    _batteryMonitor?.batteryPercent.removeListener(_onBatteryChanged);
    _batteryMonitor?.estimatedMinutesRemaining.removeListener(
      _onBatteryChanged,
    );
    _batteryMonitor?.dispose();

    // Fire off async cleanup without awaiting to keep dispose synchronous
    unawaited(_cleanupAsync());

    super.dispose();
  }

  Future<void> _cleanupAsync() async {
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
  }
}
