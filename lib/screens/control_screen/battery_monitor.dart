import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:heroctrl/services/gopro_api_service.dart';
import 'package:heroctrl/utils/logger.dart';

/// Polls the camera battery level periodically and maintains a running
/// estimate of remaining time based on confirmed percentage drops.
class BatteryMonitor {
  final String camPassword;
  final Duration pollInterval;

  final ValueNotifier<int> batteryPercent;
  final ValueNotifier<int?> estimatedMinutesRemaining = ValueNotifier(null);

  // EMA smoothing factor: each new confirmed-drop sample contributes 25% to
  // the running rate estimate, so a bad early reading quickly gets diluted.
  static const double _emaAlpha = 0.25;

  // Optimism multiplier applied to the final estimate to compensate for the
  // API's noisy / pessimistic readings. 1.3 = 30% more time than measured.
  static const double _optimismFactor = 1.3;

  Timer? _timer;
  DateTime? _lastDropTime;
  double? _avgDrainRatePerMinute;
  int? _pendingPercent; // candidate drop waiting for confirmation

  BatteryMonitor({
    required this.camPassword,
    required int initialPercent,
    this.pollInterval = const Duration(seconds: 30),
  }) : batteryPercent = ValueNotifier(initialPercent);

  void start() {
    _lastDropTime = DateTime.now();
    _timer = Timer.periodic(pollInterval, (_) => _poll());
  }

  Future<void> _poll() async {
    try {
      final now = DateTime.now();
      final newPercent = await GoProApiService.getBatteryLevel(camPassword);

      if (newPercent < batteryPercent.value) {
        if (_pendingPercent != null) {
          // Second consecutive drop reading — confirmed. Use the higher of the
          // two (most conservative / closest to current) to avoid over-dropping.
          final confirmed = _pendingPercent! > newPercent
              ? _pendingPercent!
              : newPercent;
          _pendingPercent = null;
          _recordDrop(confirmed, now);
        } else {
          // First drop reading — buffer it, wait for next poll to confirm.
          _pendingPercent = newPercent;
        }
      } else {
        // Flat or upward — discard pending noise, but recalculate estimate
        // because elapsed time without a drop means drain is slower than predicted.
        _pendingPercent = null;
        _updateEstimate(now);
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'BatteryMonitor: error polling battery level',
        e,
        stackTrace,
      );
    }
  }

  void _recordDrop(int confirmedPercent, DateTime now) {
    if (_lastDropTime != null) {
      final elapsedMinutes = now.difference(_lastDropTime!).inSeconds / 60.0;
      if (elapsedMinutes > 0) {
        final delta = (batteryPercent.value - confirmedPercent).toDouble();
        final rate = delta / elapsedMinutes;
        _avgDrainRatePerMinute = _avgDrainRatePerMinute == null
            ? rate
            : _emaAlpha * rate + (1 - _emaAlpha) * _avgDrainRatePerMinute!;
      }
    }
    _lastDropTime = now;
    batteryPercent.value = confirmedPercent;
    _updateEstimate(now);
  }

  /// Recalculates the remaining time estimate.
  ///
  /// If [now] is provided and we have a [_lastDropTime], the elapsed time
  /// since the last confirmed drop is used to produce an optimistic correction:
  /// the longer we go without a drop, the more the estimate is revised upward.
  void _updateEstimate([DateTime? now]) {
    final rate = _avgDrainRatePerMinute;
    if (rate == null || rate <= 0) return;

    double effectiveRate = rate;

    if (now != null && _lastDropTime != null) {
      final elapsedSinceLastDrop =
          now.difference(_lastDropTime!).inSeconds / 60.0;
      if (elapsedSinceLastDrop > 0) {
        // %/min we'd need to drop 1% in the time elapsed so far
        final observedRateThisTick = 1.0 / elapsedSinceLastDrop;
        if (observedRateThisTick < rate) {
          // Drain is slower than average right now — blend it in for display
          // only; _avgDrainRatePerMinute is not modified.
          effectiveRate = (rate + observedRateThisTick) / 2;
        }
      }
    }

    estimatedMinutesRemaining.value =
        (batteryPercent.value / effectiveRate * _optimismFactor).round();
  }

  void dispose() {
    _timer?.cancel();
    batteryPercent.dispose();
    estimatedMinutesRemaining.dispose();
  }
}
