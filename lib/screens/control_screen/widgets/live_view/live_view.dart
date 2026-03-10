import 'dart:async';

import 'package:flutter/material.dart';
import 'package:heroctrl/constants/gopro_action_enums.dart';
import 'package:heroctrl/constants/gopro_endpoints.dart';
import 'package:heroctrl/constants/gopro_recording_enums.dart';
import 'package:heroctrl/models/camera_state.dart';
import 'package:heroctrl/screens/control_screen/widgets/live_view/live_view_controls.dart';
import 'package:heroctrl/screens/control_screen/widgets/live_view/media_status_display.dart';
import 'package:heroctrl/services/gopro_api_service.dart';
import 'package:heroctrl/utils/logger.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class LiveView extends StatefulWidget {
  final String camPassword;
  final bool isRecording;
  final VideoResolution? currentResolution;
  final BorderRadius previewBorderRadius;
  final CameraState? cameraState;
  final Future<void> Function() onReconnect;

  const LiveView({
    super.key,
    required this.camPassword,
    this.isRecording = false,
    this.currentResolution,
    this.previewBorderRadius = const BorderRadius.all(Radius.circular(0)),
    this.cameraState,
    required this.onReconnect,
  });

  @override
  State<LiveView> createState() => _LiveViewState();
}

class _LiveViewState extends State<LiveView> {
  late final Player _player;
  late final VideoController _controller;
  late final StreamSubscription<Duration> _lengthSub;
  late final StreamSubscription<Duration> _positionSub;
  late final StreamSubscription<bool> _bufferingSub;
  static const Duration _reconnectCooldown = Duration(seconds: 2);
  Duration _duration = Duration.zero;
  bool _resettingStream = false;
  bool _wasBuffering = false;
  DateTime? _lastReconnectAt;

  void _notifyReconnect({required String source}) {
    if (!mounted) return;

    final now = DateTime.now();
    final lastReconnectAt = _lastReconnectAt;
    if (lastReconnectAt != null &&
        now.difference(lastReconnectAt) < _reconnectCooldown) {
      AppLogger.info(
        'Reconnect callback skipped due to cooldown (${_reconnectCooldown.inMilliseconds}ms) from $source',
      );
      return;
    }

    _lastReconnectAt = now;
    unawaited(widget.onReconnect());
  }

  Future<void> _fixStream() async {
    try {
      final currentMode = await GoProApiService.getCameraMode(
        widget.camPassword,
      );

      AppLogger.info(
        'Fixing stream by toggling camera mode: ${currentMode.value} -> ${CameraMode.settings.value} -> ${currentMode.value}',
      );

      await GoProApiService.setCameraMode(
        widget.camPassword,
        CameraMode.settings,
      );
      await Future.delayed(const Duration(seconds: 3));
      await GoProApiService.setCameraMode(widget.camPassword, currentMode);
      await Future.delayed(const Duration(seconds: 3));
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error toggling camera mode while fixing stream',
        e,
        stackTrace,
      );
    }

    await _openStream();
  }

  Future<void> _openStream() async {
    AppLogger.info('Opening live stream');
    try {
      await GoProApiService.startVideoPreview(widget.camPassword);
    } catch (e) {
      AppLogger.error(
        'Error starting video preview while opening stream: $e',
        e,
      );
    }
    if (!mounted) return;
    await _player.open(Media(GoProEndpoints.livestreamUrl));
    _notifyReconnect(source: 'openStream');
  }

  @override
  void initState() {
    super.initState();
    _player = Player();
    _controller = VideoController(_player);

    // Small hack to detect when the stream drops after changing modes or due to Wi-Fi issues
    // If we're more than 5s behind the live stream, reset it by reopening the stream URL
    // TODO: Find a better way to detect these
    _lengthSub = _player.stream.duration.listen((length) {
      setState(() => _duration = length);
    });
    _positionSub = _player.stream.position.listen((playback) {
      if (playback < _duration - const Duration(seconds: 10) &&
          !_resettingStream) {
        _resettingStream = true;
        AppLogger.info(
          'Playback too far behind live stream, resetting stream (position: $playback, duration: $_duration)',
        );
        if (mounted) _openStream();
      } else if (playback > _duration - const Duration(seconds: 5)) {
        _resettingStream = false;
      }
    });
    _bufferingSub = _player.stream.buffering.listen((isBuffering) {
      if (isBuffering && !_wasBuffering) {
        _notifyReconnect(source: 'bufferingStart');
      }
      _wasBuffering = isBuffering;
    });

    _openStream();
  }

  double _calculateAspectRatio() {
    try {
      switch (widget.cameraState!.status.cameraMode) {
        case CameraMode.videoMode:
          return widget.currentResolution!.aspectRatio;
        case CameraMode.photoMode:
          return 4 / 3;
        default:
          return 16 / 9;
      }
    } catch (e) {
      AppLogger.error('Error calculating aspect ratio, defaulting to 16:9', e);
    }
    return 16 / 9;
  }

  @override
  Widget build(BuildContext context) {
    final aspectRatio = _calculateAspectRatio();

    return AspectRatio(
      aspectRatio: aspectRatio,
      child: ClipRRect(
        borderRadius: widget.previewBorderRadius,
        child: Stack(
          children: [
            Video(
              controller: _controller,
              fit: BoxFit.contain,
              controls: (state) => LiveViewControls(
                player: state.widget.controller.player,
                camPassword: widget.camPassword,
                onFixStreamPressed: _fixStream,
              ),
              pauseUponEnteringBackgroundMode: false,
            ),
            if (widget.isRecording)
              IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: widget.previewBorderRadius,
                    border: Border.all(color: Colors.red, width: 3.0),
                  ),
                ),
              ),
            MediaStatusDisplay(cameraState: widget.cameraState),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _lengthSub.cancel();
    _positionSub.cancel();
    _bufferingSub.cancel();
    _player.dispose();
    super.dispose();
  }
}
