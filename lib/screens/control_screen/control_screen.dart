import 'dart:async';

import 'package:flutter/material.dart';
import 'package:heroctrl/models/camera_state.dart';
import 'package:heroctrl/screens/control_screen/battery_monitor.dart';
import 'package:heroctrl/screens/control_screen/widgets/battery_indicator.dart';
import 'package:heroctrl/screens/control_screen/widgets/live_view/live_view.dart';
import 'package:heroctrl/screens/control_screen/layouts/horizontal_layout.dart';
import 'package:heroctrl/screens/control_screen/layouts/vertical_layout.dart';
import 'package:heroctrl/services/app_prefs.dart';
import 'package:heroctrl/services/gopro_connection_service.dart';
import 'package:heroctrl/services/gopro_api_service.dart';
import 'package:heroctrl/l10n/app_localizations.dart';
import 'package:heroctrl/utils/app_routes.dart';
import 'package:heroctrl/utils/logger.dart';
import 'package:heroctrl/utils/snackbar.dart';
import 'package:heroctrl/utils/camera_state_conditions.dart';

class ControlScreen extends StatefulWidget {
  const ControlScreen({super.key});

  @override
  State<ControlScreen> createState() => _RegisterControlScreenState();
}

class _RegisterControlScreenState extends State<ControlScreen> {
  final String _password = GoProConnectionService.password ?? '';
  CameraState? _cameraState;
  BatteryMonitor? _batteryMonitor;
  bool _isAutoDisconnectingForLowBattery = false;
  bool _hasScheduledDisconnectRedirect = false;

  void _redirectToHomeOnDisconnected({bool showMessage = true}) {
    if (_hasScheduledDisconnectRedirect) return;
    _hasScheduledDisconnectRedirect = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (showMessage) {
        showSnackBarError(context, 'No camera connection found');
      }
      Navigator.of(context).popUntil(ModalRoute.withName(AppRoutes.home));
    });
  }

  @override
  void initState() {
    super.initState();
    AppLogger.info('ControlScreen: initState called');
    if (!GoProConnectionService.isConnected) {
      AppLogger.warning(
        'ControlScreen initialized without an active camera connection',
      );
      _redirectToHomeOnDisconnected();
      return;
    } else {
      AppLogger.info('Camera connection found, fetching initial camera state');
      _fetchCameraState();
    }
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
        monitor.trueReading.addListener(_onBatteryChanged);
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
    _refreshCameraStatus();
    _checkLowBatteryAndDisconnect();
  }

  void _checkLowBatteryAndDisconnect() {
    final batteryPercent = _batteryMonitor?.batteryPercent.value;
    final trueReading = _batteryMonitor?.trueReading.value;

    if (!mounted ||
        _isAutoDisconnectingForLowBattery ||
        batteryPercent == null ||
        trueReading == null) {
      return;
    }

    if (batteryPercent <= 1 || trueReading <= 1) {
      _isAutoDisconnectingForLowBattery = true;
      final l10n = AppLocalizations.of(context)!;
      showSnackBarWarning(context, l10n.batteryCriticallyLow);
      Navigator.of(context).popUntil(ModalRoute.withName(AppRoutes.home));
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

  Future<void> _refreshCameraStatus() async {
    try {
      final previousMode = _cameraState?.status.cameraMode;
      final updatedStatus = await GoProApiService.getStatus(
        _password,
        fallbackCameraMode: previousMode,
      );
      if (mounted && _cameraState != null) {
        setState(() {
          _cameraState!.status = updatedStatus;
        });
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error refreshing camera status', e, stackTrace);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!GoProConnectionService.isConnected) {
      _redirectToHomeOnDisconnected(showMessage: false);
      return Scaffold(
        appBar: AppBar(title: const Text('Camera Control')),
        body: const SizedBox.shrink(),
      );
    }

    final Widget previewArea;
    if (CameraStateConditions.isPreviewOn(_cameraState) &&
        CameraStateConditions.isCameraOn(_cameraState) &&
        !CameraStateConditions.isInSettingsMode(_cameraState)) {
      previewArea = LiveView(
        camPassword: _password,
        isRecording: CameraStateConditions.isRecording(_cameraState),
        currentResolution: _cameraState!.status.videoResolution,
        previewBorderRadius: isLandscape(context)
            ? const BorderRadius.all(Radius.circular(12))
            : const BorderRadius.all(Radius.circular(0)),
        cameraState: _cameraState,
        onReconnect: _refreshCameraStatus,
      );
    } else if (CameraStateConditions.isInSettingsMode(_cameraState)) {
      previewArea = Text(
        AppLocalizations.of(context)!.liveViewUnavailableInSettings,
      );
    } else {
      previewArea = Padding(
        padding: const EdgeInsets.all(100.0),
        child: CircularProgressIndicator(),
      );
    }

    final content = isLandscape(context)
        ? HorizontalLayout(
            previewArea:
                CameraStateConditions.isPreviewOn(_cameraState) &&
                    CameraStateConditions.isCameraOn(_cameraState) &&
                    !CameraStateConditions.isInSettingsMode(_cameraState)
                ? previewArea
                : Center(child: previewArea),
            cameraState: _cameraState,
            password: _password,
            onSettingChanged: _refreshCameraStatus,
          )
        : VerticalLayout(
            previewArea:
                CameraStateConditions.isPreviewOn(_cameraState) &&
                    CameraStateConditions.isCameraOn(_cameraState) &&
                    !CameraStateConditions.isInSettingsMode(_cameraState)
                ? previewArea
                : Center(child: previewArea),
            cameraState: _cameraState,
            password: _password,
            onSettingChanged: _refreshCameraStatus,
          );

    return Scaffold(
      appBar: AppBar(
        title: Text(GoProConnectionService.ssid ?? 'Camera Control'),
        actions: [
          if (_batteryMonitor != null)
            BatteryIndicator(
              batteryPercent: _batteryMonitor!.batteryPercent.value,
              estimatedMinutesRemaining:
                  _batteryMonitor!.estimatedMinutesRemaining.value,
            ),
          if (CameraStateConditions.isCameraOn(_cameraState))
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
      body: SafeArea(top: false, child: Center(child: content)),
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
    if (GoProConnectionService.isConnected &&
        await AppPrefs.getSwitchOffCameraOnDisconnect()) {
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
