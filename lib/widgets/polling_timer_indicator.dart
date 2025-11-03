import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PollingTimerIndicator extends StatefulWidget {
  final DateTime? nextPollTime;
  // optional external notifier you can update from outside (preferred)
  final ValueListenable<DateTime?>? nextPollTimeListenable;
  final int pollIntervalSeconds;
  final double size;
  final Color? color;
  final TextStyle? textStyle;

  const PollingTimerIndicator({
    super.key,
    required this.nextPollTime,
    this.nextPollTimeListenable,
    this.pollIntervalSeconds = 30,
    this.size = 40,
    this.color,
    this.textStyle,
  });

  @override
  State<PollingTimerIndicator> createState() => _PollingTimerIndicatorState();
}

class _PollingTimerIndicatorState extends State<PollingTimerIndicator> {
  Timer? _tickTimer;
  VoidCallback? _externalListener;

  @override
  void initState() {
    super.initState();
    // if an external listable is provided, listen to it; otherwise run an internal tick timer
    if (widget.nextPollTimeListenable != null) {
      _externalListener = () {
        if (!mounted) return;
        setState(() {});
      };
      widget.nextPollTimeListenable!.addListener(_externalListener!);
    } else {
      _tickTimer = Timer.periodic(const Duration(milliseconds: 200), (_) {
        if (!mounted) return;
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    _tickTimer?.cancel();
    if (_externalListener != null) {
      widget.nextPollTimeListenable?.removeListener(_externalListener!);
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant PollingTimerIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    // swap between external listable and internal timer if prop changed
    if (oldWidget.nextPollTimeListenable != widget.nextPollTimeListenable) {
      // remove old
      if (oldWidget.nextPollTimeListenable != null &&
          _externalListener != null) {
        oldWidget.nextPollTimeListenable!.removeListener(_externalListener!);
      }
      // cancel internal timer
      _tickTimer?.cancel();
      _tickTimer = null;
      _externalListener = null;
      // attach new
      if (widget.nextPollTimeListenable != null) {
        _externalListener = () {
          if (!mounted) return;
          setState(() {});
        };
        widget.nextPollTimeListenable!.addListener(_externalListener!);
      } else {
        _tickTimer = Timer.periodic(const Duration(milliseconds: 200), (_) {
          if (!mounted) return;
          setState(() {});
        });
      }
    }
  }

  double get _progress {
    final next = widget.nextPollTime;
    final externalNext = widget.nextPollTimeListenable?.value;
    final effectiveNext = externalNext ?? next;
    if (effectiveNext == null) return 0.0;
    final remainingMs = effectiveNext.difference(DateTime.now()).inMilliseconds;
    final totalMs = widget.pollIntervalSeconds * 1000;
    final progress = 1.0 - (remainingMs / totalMs);
    return progress.clamp(0.0, 1.0);
  }

  int get _secondsLeft {
    final externalNext = widget.nextPollTimeListenable?.value;
    final effectiveNext = externalNext ?? widget.nextPollTime;
    if (effectiveNext == null) return widget.pollIntervalSeconds;
    final secs = effectiveNext.difference(DateTime.now()).inSeconds;
    return max(0, secs);
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? Colors.black54;
    final textStyle =
        widget.textStyle ??
        TextStyle(fontSize: max(10, widget.size * 0.28), color: color);
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: _progress,
            strokeWidth: max(2.0, widget.size * 0.09),
            color: color,
          ),
          Text('$_secondsLeft', style: textStyle),
        ],
      ),
    );
  }
}
