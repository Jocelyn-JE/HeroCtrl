import 'package:flutter/material.dart';
import 'package:heroctrl/models/camera_state.dart';
import 'package:heroctrl/services/gopro_api_service.dart';
import 'package:heroctrl/utils/camera_state_conditions.dart';
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

  Future<void> _handleShutterPress() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      if (CameraStateConditions.isInPhotoOrBurstMode(widget.cameraState)) {
        AppLogger.info('Capturing photo');
        await GoProApiService.startShutter(widget.password);
      } else {
        // Video/Timelapse mode: toggle recording
        if (CameraStateConditions.isShutterDown(widget.cameraState)) {
          AppLogger.info('Stopping recording');
          await GoProApiService.stopShutter(widget.password);
        } else {
          AppLogger.info('Starting recording');
          await GoProApiService.startShutter(widget.password);
        }

        // Give camera a moment to update its internal state
        await Future.delayed(const Duration(milliseconds: 500));
      }

      // Refresh camera status
      await widget.onStatusUpdated();
    } catch (e, stackTrace) {
      AppLogger.error('Error toggling shutter', e, stackTrace);
      if (mounted) {
        final action =
            CameraStateConditions.isInPhotoOrBurstMode(widget.cameraState)
            ? 'capture photo'
            : (CameraStateConditions.isShutterDown(widget.cameraState)
                  ? 'stop recording'
                  : 'start recording');
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
    if (CameraStateConditions.isInSettingsMode(widget.cameraState)) {
      return const SizedBox.shrink();
    }

    final isVideoMode = CameraStateConditions.isInVideoOrTimelapseMode(
      widget.cameraState,
    );
    final isShutterDown = CameraStateConditions.isShutterDown(
      widget.cameraState,
    );

    if (isVideoMode) {
      // Video/Timelapse mode: recording button
      return FloatingActionButton(
        onPressed: _isLoading ? null : _handleShutterPress,
        backgroundColor: isShutterDown ? Colors.red : Colors.white,
        foregroundColor: isShutterDown ? Colors.white : Colors.red,
        heroTag: 'recordButton',
        elevation: 6,
        child: Icon(
          isShutterDown ? Icons.stop_rounded : Icons.circle,
          size: isShutterDown ? 28 : 32,
        ),
      );
    } else {
      // Photo/Burst mode: camera button with animated capture border
      return FloatingActionButton(
        onPressed: _isLoading ? null : _handleShutterPress,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        heroTag: 'recordButton',
        elevation: 6,
        child: Icon(
          CameraStateConditions.isInPhotoMode(widget.cameraState)
              ? Icons.camera_alt
              : Icons.burst_mode,
          size: 28,
        ),
      );
    }
  }
}
