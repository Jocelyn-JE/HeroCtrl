import 'package:flutter/material.dart';
import 'package:heroctrl/constants/gopro_endpoints.dart';
import 'package:heroctrl/models/camera_state.dart';
import 'package:heroctrl/utils/logger.dart';

class ResolutionSelector extends StatelessWidget {
  final CameraState cameraState;
  final String password;
  final Future<void> Function(VideoResolution) onResolutionChanged;

  const ResolutionSelector({
    super.key,
    required this.cameraState,
    required this.password,
    required this.onResolutionChanged,
  });

  @override
  Widget build(BuildContext context) {
    final VideoResolution currentResolution =
        cameraState.status.videoResolution;

    // Ensure the current value exists in the dropdown items
    final VideoResolution? selectedValue =
        VideoResolution.all.contains(currentResolution)
        ? currentResolution
        : null;

    return Container(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButton<VideoResolution>(
        value: selectedValue,
        onChanged: (cameraState.isCameraOn)
            ? (newValue) {
                if (newValue != null) {
                  AppLogger.info(
                    'Changing video resolution to ${newValue.getLocalizedName(context)}',
                  );
                  onResolutionChanged(newValue);
                }
              }
            : null,
        items: VideoResolution.all
            .map(
              (resolution) => DropdownMenuItem(
                value: resolution,
                child: Text(resolution.getLocalizedName(context)),
              ),
            )
            .toList(),
      ),
    );
  }
}
