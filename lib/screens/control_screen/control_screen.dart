import 'package:flutter/material.dart';
import 'package:heroctrl/screens/control_screen/widgets/live_view.dart';
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
  bool _isPreviewStarted = false;

  @override
  void initState() {
    super.initState();
    AppLogger.info('ControlScreen: initState called');
    _checkPreviewStatus();
  }

  Future<void> _checkPreviewStatus() async {
    try {
      final password = GoProConnectionService.currentConnection!.password;
      AppLogger.info('Waiting for camera to power on...');
      await GoProApiService.waitUntilCameraOn(password);
      AppLogger.info('Camera is on, waiting for preview to be enabled...');
      await GoProApiService.waitUntilPreviewOn(password);
      AppLogger.info('Preview is enabled, waiting for stream to stabilize...');
      // Give the camera a few seconds for the HLS stream to become available
      await Future.delayed(const Duration(seconds: 3));
      final isOn = true;
      AppLogger.info('Preview status: ON');
      if (mounted) {
        setState(() {
          _isPreviewStarted = isOn;
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
        actions: [],
      ),
      body: SafeArea(
        bottom: true,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isPreviewStarted)
                const LiveView()
              else
                const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    GoProConnectionService.disconnect();
    super.dispose();
  }
}
