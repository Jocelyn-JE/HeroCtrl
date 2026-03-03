import 'package:flutter/material.dart';
import 'package:heroctrl/constants/gopro_action_enums.dart';
import 'package:heroctrl/models/camera_state.dart';
import 'package:heroctrl/services/gopro_api_service.dart';
import 'package:heroctrl/utils/logger.dart';
import 'package:heroctrl/utils/snackbar.dart';

class RecordButton extends StatefulWidget {
  final CameraState cameraState;
  final String password;
  final Future<void> Function() onStatusUpdated;

  const RecordButton({
    super.key,
    required this.cameraState,
    required this.password,
    required this.onStatusUpdated,
  });

  @override
  State<RecordButton> createState() => _RecordButtonState();
}

class _RecordButtonState extends State<RecordButton> {
  bool _isLoading = false;

  bool _shouldShowButton() {
    final mode = widget.cameraState.status.cameraMode;
    return mode == CameraMode.videoMode ||
        mode == CameraMode.photoMode ||
        mode == CameraMode.burstMode ||
        mode == CameraMode.timelapseMode;
  }

  bool _isRecording() {
    return widget.cameraState.status.shutterStatus;
  }

  bool _isVideoOrTimelapse() {
    final mode = widget.cameraState.status.cameraMode;
    return mode == CameraMode.videoMode || mode == CameraMode.timelapseMode;
  }

  Future<void> _handleShutterPress() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      if (_isRecording()) {
        AppLogger.info('Stopping recording/shutter');
        await GoProApiService.stopShutter(widget.password);
      } else {
        AppLogger.info('Starting recording/shutter');
        await GoProApiService.startShutter(widget.password);
      }

      // Give camera a moment to update its internal state
      await Future.delayed(const Duration(milliseconds: 500));

      // Refresh camera status
      await widget.onStatusUpdated();
    } catch (e, stackTrace) {
      AppLogger.error('Error toggling shutter', e, stackTrace);
      if (mounted) {
        final action = _isRecording() ? 'stop recording' : 'start recording';
        showSnackBarError(context, 'Error: Cannot $action: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_shouldShowButton()) {
      return const SizedBox.shrink();
    }

    final isVideoMode = _isVideoOrTimelapse();
    final isRecording = _isRecording();

    if (isVideoMode) {
      // Video/Timelapse mode: recording button
      return FloatingActionButton(
        onPressed: _isLoading ? null : _handleShutterPress,
        backgroundColor: isRecording ? Colors.red : Colors.white,
        foregroundColor: isRecording ? Colors.white : Colors.red,
        heroTag: 'recordButton',
        elevation: 6,
        child: Icon(
          isRecording ? Icons.stop_rounded : Icons.circle,
          size: isRecording ? 28 : 32,
        ),
      );
    } else {
      // Photo/Burst mode: camera button
      return FloatingActionButton(
        onPressed: _isLoading ? null : _handleShutterPress,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        heroTag: 'recordButton',
        elevation: 6,
        child: const Icon(Icons.camera_alt, size: 28),
      );
    }
  }
}
