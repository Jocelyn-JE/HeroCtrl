import 'dart:async';

import 'package:flutter/material.dart';
import 'package:better_player_plus/better_player_plus.dart';
import 'package:heroctrl/constants/gopro_endpoints.dart';
import 'package:heroctrl/services/gopro_api_service.dart';
import 'package:heroctrl/utils/logger.dart';

class LiveView extends StatefulWidget {
  final String camPassword;

  const LiveView({super.key, required this.camPassword});

  @override
  State<LiveView> createState() => _LiveViewState();
}

class _LiveViewState extends State<LiveView> {
  late BetterPlayerController controller;
  late BetterPlayerDataSource _dataSource;

  bool _isReconnecting = false;
  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;
  static const int _maxReconnectDelay = 30; // seconds

  @override
  void initState() {
    super.initState();
    _dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      GoProEndpoints.livestreamUrl,
      liveStream: true,
      notificationConfiguration: const BetterPlayerNotificationConfiguration(
        showNotification: false,
      ),
    );
    controller = BetterPlayerController(
      BetterPlayerConfiguration(
        fit: BoxFit.contain,
        autoPlay: true,
        looping: true,
        controlsConfiguration: const BetterPlayerControlsConfiguration(
          showControls: true,
          enablePlayPause: false,
          enableFullscreen: true,
          enableSkips: false,
          enableProgressBar: false,
          enableProgressText: false,
          enableMute: true,
          enablePlaybackSpeed: false,
          enablePip: false,
          enableOverflowMenu: false,
          controlBarColor: Colors.transparent,
          controlsHideTime: Duration.zero,
          liveTextColor: Colors.transparent,
        ),
        eventListener: _onPlayerEvent,
      ),
      betterPlayerDataSource: _dataSource,
    );
    controller.setVolume(0.0);
  }

  void _onPlayerEvent(BetterPlayerEvent event) {
    switch (event.betterPlayerEventType) {
      case BetterPlayerEventType.hideFullscreen:
        // Reconnect immediately after leaving fullscreen (no backoff needed).
        _scheduleReconnect(delay: Duration.zero);
        break;
      case BetterPlayerEventType.exception:
      case BetterPlayerEventType.finished:
        _scheduleReconnect();
        break;
      default:
        break;
    }
  }

  /// Schedules a reconnect attempt with optional exponential backoff.
  /// If a reconnect is already pending or in progress, this is a no-op.
  void _scheduleReconnect({Duration? delay}) {
    if (_isReconnecting) return;
    _isReconnecting = true;

    // Exponential backoff: 2^attempts seconds, capped at _maxReconnectDelay.
    final backoffSeconds = delay == null
        ? (_reconnectAttempts == 0
              ? 2
              : (2 << (_reconnectAttempts - 1)).clamp(2, _maxReconnectDelay))
        : delay.inSeconds;

    AppLogger.info(
      'LiveView: stream error, reconnecting in ${backoffSeconds}s '
      '(attempt ${_reconnectAttempts + 1})',
    );

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(Duration(seconds: backoffSeconds), _reconnect);
  }

  Future<void> _reconnect() async {
    if (!mounted) return;
    try {
      // Ask the camera to re-enable its preview stream before reconnecting.
      // Per API docs: 'If the preview freezes, enable it again to unfreeze it'.
      await GoProApiService.startVideoPreview(widget.camPassword);
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      await controller.setupDataSource(_dataSource);
      _reconnectAttempts = 0; // success — reset backoff
      AppLogger.info('LiveView: stream reconnected successfully');
    } catch (e, stackTrace) {
      AppLogger.error('LiveView: reconnect failed', e, stackTrace);
      _reconnectAttempts++;
    } finally {
      _isReconnecting = false;
    }
  }

  @override
  void dispose() {
    _reconnectTimer?.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BetterPlayer(controller: controller);
  }
}
