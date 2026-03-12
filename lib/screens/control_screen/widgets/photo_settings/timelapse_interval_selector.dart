import 'package:flutter/material.dart';
import 'package:heroctrl/gopro_settings/photo/timelapse_interval.dart';
import 'package:heroctrl/models/camera_state.dart';
import 'package:heroctrl/services/gopro_api_service.dart';
import 'package:heroctrl/utils/logger.dart';

class TimelapseIntervalSelector extends StatelessWidget {
  final CameraState cameraState;
  final String password;
  final Future<void> Function() onIntervalChanged;
  final EdgeInsetsGeometry padding;

  const TimelapseIntervalSelector({
    super.key,
    required this.cameraState,
    required this.password,
    required this.onIntervalChanged,
    this.padding = const EdgeInsets.all(8.0),
  });

  @override
  Widget build(BuildContext context) {
    final TimelapseInterval currentInterval =
        cameraState.status.timelapseInterval;

    final TimelapseInterval? selectedValue =
        TimelapseInterval.all.contains(currentInterval)
        ? currentInterval
        : null;

    return Padding(
      padding: padding,
      child: DropdownButton<TimelapseInterval>(
        isExpanded: true,
        value: selectedValue,
        onChanged: cameraState.isCameraOn
            ? (newValue) {
                if (newValue != null) {
                  AppLogger.info(
                    'Changing timelapse interval to ${newValue.getLocalizedName(context)}',
                  );
                  GoProApiService.setTimelapseInterval(password, newValue).then(
                    (_) {
                      onIntervalChanged();
                    },
                  );
                }
              }
            : null,
        items: TimelapseInterval.all
            .map(
              (interval) => DropdownMenuItem(
                value: interval,
                child: Text(interval.getLocalizedName(context)),
              ),
            )
            .toList(),
      ),
    );
  }
}
