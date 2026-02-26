import 'package:flutter/material.dart';
import 'package:better_player_plus/better_player_plus.dart';
import 'package:heroctrl/constants/gopro_endpoints.dart';

class LiveView extends StatefulWidget {
  const LiveView({super.key});

  @override
  State<LiveView> createState() => _LiveViewState();
}

class _LiveViewState extends State<LiveView> {
  late BetterPlayerController controller;
  late BetterPlayerDataSource _dataSource;

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
    // Set volume to 0 (muted) by default
    controller.setVolume(0.0);
  }

  void _onPlayerEvent(BetterPlayerEvent event) {
    switch (event.betterPlayerEventType) {
      case BetterPlayerEventType.hideFullscreen:
        controller.setupDataSource(_dataSource);
        break;
      case BetterPlayerEventType.exception:
        controller.setupDataSource(_dataSource);
        break;
      case BetterPlayerEventType.finished:
        controller.setupDataSource(_dataSource);
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BetterPlayer(controller: controller);
  }
}
