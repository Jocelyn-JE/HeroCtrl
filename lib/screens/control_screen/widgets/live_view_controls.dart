import 'dart:async';

import 'package:flutter/material.dart';
import 'package:heroctrl/screens/control_screen/widgets/fix_stream_button.dart';
import 'package:media_kit/media_kit.dart';

class LiveViewControls extends StatefulWidget {
  final Player player;
  final String camPassword;
  final Future<void> Function() onFixStreamPressed;

  const LiveViewControls({
    super.key,
    required this.player,
    required this.camPassword,
    required this.onFixStreamPressed,
  });

  @override
  State<LiveViewControls> createState() => _LiveViewControlsState();
}

class _LiveViewControlsState extends State<LiveViewControls> {
  bool _controlsVisible = false;
  Timer? _controlsHideTimer;
  bool _isMuted = true;

  void _toggleControls() {
    setState(() {
      _controlsVisible = !_controlsVisible;
    });

    if (_controlsVisible) {
      _restartControlsAutoHide();
    } else {
      _controlsHideTimer?.cancel();
    }
  }

  void _restartControlsAutoHide() {
    _controlsHideTimer?.cancel();
    _controlsHideTimer = Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() {
        _controlsVisible = false;
      });
    });
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
    });
    if (_isMuted) {
      widget.player.setVolume(0);
    } else {
      widget.player.setVolume(100);
    }
    _restartControlsAutoHide();
  }

  @override
  void initState() {
    super.initState();
    widget.player.setVolume(0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _toggleControls,
      child: Stack(
        fit: StackFit.expand,
        children: [
          StreamBuilder<bool>(
            stream: widget.player.stream.buffering,
            builder: (context, snapshot) {
              final isBuffering = snapshot.data ?? false;
              if (!isBuffering) {
                return const SizedBox.shrink();
              }
              return Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Center(
              child: IgnorePointer(
                ignoring: !_controlsVisible,
                child: AnimatedOpacity(
                  opacity: _controlsVisible ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeInOut,
                  child: FixStreamButton(
                    camPassword: widget.camPassword,
                    onFixStreamPressed: widget.onFixStreamPressed,
                    onPressedComplete: _toggleControls,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            child: IgnorePointer(
              ignoring: !_controlsVisible,
              child: AnimatedOpacity(
                opacity: _controlsVisible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeInOut,
                child: FloatingActionButton(
                  onPressed: _toggleMute,
                  child: Icon(_isMuted ? Icons.volume_off : Icons.volume_up),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controlsHideTimer?.cancel();
    super.dispose();
  }
}
