import 'dart:async';

import 'package:flutter/material.dart';
import 'package:better_player_plus/better_player_plus.dart';
import 'package:heroctrl/constants/gopro_endpoints.dart';
import 'package:heroctrl/services/gopro_api_service.dart';
import 'package:heroctrl/utils/logger.dart';
import 'package:http/http.dart' as http;

class LiveView extends StatefulWidget {
  final String camPassword;

  const LiveView({super.key, required this.camPassword});

  @override
  State<LiveView> createState() => _LiveViewState();
}

class _LiveViewState extends State<LiveView> {
  late BetterPlayerController controller;

  bool _isReconnecting = false;
  int _reconnectAttempts = 0;
  static const int _maxReconnectDelay = 30; // seconds
  static const Duration _healthCheckInterval = Duration(seconds: 20);
  Timer? _healthCheckTimer;

  @override
  void initState() {
    super.initState();
    controller = BetterPlayerController(
      BetterPlayerConfiguration(
        fit: BoxFit.contain,
        autoPlay: true,
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
      betterPlayerDataSource: _freshDataSource(),
    );
    controller.setVolume(0.0);
    _startHealthCheck();
  }

  /// Returns a data source with a cache-busting timestamp on the URL so
  /// ExoPlayer always fetches a fresh manifest instead of replaying buffered
  /// segments from a previous session.
  BetterPlayerDataSource _freshDataSource() {
    final url =
        '${GoProEndpoints.livestreamUrl}?_=${DateTime.now().millisecondsSinceEpoch}';
    return BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      url,
      liveStream: true,
      notificationConfiguration: const BetterPlayerNotificationConfiguration(
        showNotification: false,
      ),
    );
  }

  void _startHealthCheck() {
    _healthCheckTimer?.cancel();
    _healthCheckTimer = Timer.periodic(_healthCheckInterval, (_) async {
      if (_isReconnecting) return;
      try {
        final response = await http
            .get(Uri.parse(GoProEndpoints.livestreamUrl))
            .timeout(const Duration(seconds: 5));
        if (response.statusCode != 200) {
          AppLogger.info(
            'LiveView: health check failed (HTTP ${response.statusCode}), reconnecting',
          );
          _triggerReconnect();
        }
      } catch (_) {
        AppLogger.info(
          'LiveView: health check failed (unreachable), reconnecting',
        );
        _triggerReconnect();
      }
    });
  }

  void _onPlayerEvent(BetterPlayerEvent event) {
    if (event.betterPlayerEventType == BetterPlayerEventType.hideFullscreen) {
      // Reconnect immediately when leaving fullscreen to get a fresh frame.
      _triggerReconnect(delay: Duration.zero);
    }
    // All other BetterPlayer events (including 'exception' and 'finished') are
    // intentionally ignored — the camera's HLS segmentation causes BetterPlayer
    // to misfire these at every segment boundary. The health check handles real
    // drops instead.
  }

  void _triggerReconnect({Duration? delay}) {
    if (_isReconnecting) return;
    _isReconnecting = true;

    final backoffSeconds = delay == null
        ? (_reconnectAttempts == 0
              ? 2
              : (2 << (_reconnectAttempts - 1)).clamp(2, _maxReconnectDelay))
        : delay.inSeconds;

    AppLogger.info(
      'LiveView: reconnecting in ${backoffSeconds}s '
      '(attempt ${_reconnectAttempts + 1})',
    );

    Future.delayed(Duration(seconds: backoffSeconds), _reconnect);
  }

  Future<void> _reconnect() async {
    if (!mounted) return;
    try {
      await GoProApiService.startVideoPreview(widget.camPassword);
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      await controller.setupDataSource(_freshDataSource());
      _reconnectAttempts = 0;
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
    _healthCheckTimer?.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BetterPlayer(controller: controller);
  }
}
