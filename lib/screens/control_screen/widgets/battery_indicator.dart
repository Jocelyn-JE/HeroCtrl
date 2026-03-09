import 'package:flutter/material.dart';

/// Displays a Material battery icon (0–6 bars) derived from [batteryPercent] with the percentage label below.
class BatteryIndicator extends StatelessWidget {
  final int batteryPercent;
  final int? estimatedMinutesRemaining;

  const BatteryIndicator({
    super.key,
    required this.batteryPercent,
    this.estimatedMinutesRemaining,
  });

  static String _formatTime(int minutes) {
    if (minutes < 60) return '~${minutes}m';
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return m == 0 ? '~${h}h' : '~${h}h${m}m';
  }

  static const _icons = [
    Icons.battery_0_bar,
    Icons.battery_1_bar,
    Icons.battery_2_bar,
    Icons.battery_3_bar,
    Icons.battery_4_bar,
    Icons.battery_5_bar,
    Icons.battery_6_bar,
  ];

  @override
  Widget build(BuildContext context) {
    final bool isCritical = batteryPercent < 5;
    final bool isLow = batteryPercent < 10;
    final Color fallbackColor = Theme.of(context).colorScheme.onSurface;
    final Color color = isLow
        ? Colors.red
        : IconTheme.of(context).color ?? fallbackColor;
    final IconData icon = isCritical
        ? Icons.battery_alert
        : _icons[((batteryPercent / 100) * 6).round().clamp(0, 6)];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color),
            Transform.translate(
              offset: const Offset(-2, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$batteryPercent%',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  if (estimatedMinutesRemaining != null)
                    Text(
                      _formatTime(estimatedMinutesRemaining!),
                      style: TextStyle(fontSize: 9, color: color),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
