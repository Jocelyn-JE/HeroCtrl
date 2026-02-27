import 'dart:async';

import 'package:flutter/material.dart';
import 'package:heroctrl/constants/gopro_endpoints.dart';
import 'package:heroctrl/services/gopro_api_service.dart';
import 'package:heroctrl/utils/logger.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class LiveView extends StatefulWidget {
  final String camPassword;

  const LiveView({super.key, required this.camPassword});

  @override
  State<LiveView> createState() => _LiveViewState();
}

class _LiveViewState extends State<LiveView> {
  late final Player _player;
  late final VideoController _controller;
  late final StreamSubscription<Duration> _lengthSub;
  late final StreamSubscription<Duration> _positionSub;
  Duration _duration = Duration.zero;
  bool _resettingStream = false;

  Future<void> _openStream() async {
    AppLogger.info('Opening live stream');
    try {
      await GoProApiService.startVideoPreview(widget.camPassword);
    } catch (e) {
      // Preview may already be on or camera is returning an error — proceed anyway
    }
    await _player.open(Media(GoProEndpoints.livestreamUrl));
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
      if (playback < _duration - const Duration(seconds: 5) &&
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

    _openStream();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Video(controller: _controller),
        ),
        ElevatedButton(
          onPressed: () async {
            _openStream();
          },
          child: const Text('Fix Stream'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _lengthSub.cancel();
    _positionSub.cancel();
    _player.dispose();
    super.dispose();
  }
}
