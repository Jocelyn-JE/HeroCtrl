import 'dart:async';

import 'package:flutter/material.dart';
import 'package:heroctrl/constants/gopro_action_enums.dart';
import 'package:heroctrl/models/camera_state.dart';

class MediaStatusDisplay extends StatefulWidget {
  final CameraState? cameraState;

  const MediaStatusDisplay({super.key, required this.cameraState});

  @override
  State<MediaStatusDisplay> createState() => _MediaStatusDisplayState();
}

class _MediaStatusDisplayState extends State<MediaStatusDisplay> {
  int _elapsedSeconds = 0;
  Timer? _recordingTimer;

  bool _isRecording(CameraState? cameraState) {
    if (cameraState == null) {
      return false;
    }

    final status = cameraState.status;
    return status.cameraMode == CameraMode.videoMode && status.shutterStatus;
  }

  void _startRecordingTimer({bool resetElapsed = false}) {
    if (resetElapsed) {
      _elapsedSeconds = 0;
    }

    _recordingTimer?.cancel();
    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _elapsedSeconds++;
      });
    });
  }

  void _stopRecordingTimer() {
    _recordingTimer?.cancel();
    _recordingTimer = null;
  }

  @override
  void initState() {
    super.initState();

    if (_isRecording(widget.cameraState)) {
      _startRecordingTimer(resetElapsed: true);
    }
  }

  @override
  void didUpdateWidget(covariant MediaStatusDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);

    final wasRecording = _isRecording(oldWidget.cameraState);
    final isRecording = _isRecording(widget.cameraState);

    if (isRecording && !wasRecording) {
      _startRecordingTimer(resetElapsed: true);
      return;
    }

    if (!isRecording && wasRecording) {
      _stopRecordingTimer();
      return;
    }

    if (isRecording && _recordingTimer == null) {
      _startRecordingTimer();
    }
  }

  @override
  void dispose() {
    _stopRecordingTimer();
    super.dispose();
  }

  String _formatDuration(int totalSeconds) {
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;

    if (hours > 0) {
      return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }

  String _formatVideoTime(int minutes) {
    if (minutes < 60) {
      return '${minutes}m';
    } else {
      final hours = minutes ~/ 60;
      final mins = minutes % 60;
      return '${hours}h ${mins}m';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.cameraState == null) {
      return const SizedBox.shrink();
    }

    final status = widget.cameraState!.status;
    final isCameraOnAndPreviewOn =
        widget.cameraState!.isCameraOn && widget.cameraState!.isPreviewOn;

    if (!isCameraOnAndPreviewOn) {
      return const SizedBox.shrink();
    }

    // If recording in video mode, show recording progress
    if (status.shutterStatus && status.cameraMode == CameraMode.videoMode) {
      final recordingTimeFormatted = _formatDuration(_elapsedSeconds);
      return Positioned(
        top: 8,
        right: 8,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.red.withAlpha((0.7 * 255).round()),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.videocam, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text(
                recordingTimeFormatted,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Show remaining photos for photo/burst/timelapse modes
    if (status.cameraMode == CameraMode.photoMode ||
        status.cameraMode == CameraMode.burstMode ||
        status.cameraMode == CameraMode.timelapseMode) {
      return Positioned(
        top: 8,
        right: 8,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black.withAlpha((0.6 * 255).round()),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.image, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text(
                '${status.photosRemaining}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Show remaining video time for video mode (when not recording)
    if (status.cameraMode == CameraMode.videoMode) {
      final videoTimeFormatted = _formatVideoTime(
        status.recordingTimeRemaining,
      );
      return Positioned(
        top: 8,
        right: 8,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black.withAlpha((0.6 * 255).round()),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.videocam, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text(
                videoTimeFormatted,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
