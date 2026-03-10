import 'package:flutter/material.dart';
import 'package:heroctrl/constants/gopro_recording_enums.dart';
import 'package:heroctrl/models/camera_state.dart';
import 'package:heroctrl/services/gopro_api_service.dart';
import 'package:heroctrl/utils/logger.dart';

class ResolutionSelector extends StatelessWidget {
  final CameraState cameraState;
  final String password;
  final Future<void> Function() onResolutionChanged;
  final EdgeInsetsGeometry padding;

  const ResolutionSelector({
    super.key,
    required this.cameraState,
    required this.password,
    required this.onResolutionChanged,
    this.padding = const EdgeInsets.all(8.0),
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

    return Padding(
      padding: padding,
      child: DropdownButton<VideoResolution>(
        isExpanded: true,
        value: selectedValue,
        onChanged: (cameraState.isCameraOn)
            ? (newValue) {
                if (newValue != null) {
                  AppLogger.info(
                    'Changing video resolution to ${newValue.getLocalizedName(context)}',
                  );
                  GoProApiService.setVideoResolution(password, newValue).then((
                    _,
                  ) {
                    onResolutionChanged();
                  });
                }
              }
            : null,
        items: VideoResolution.all
            .map(
              (resolution) => DropdownMenuItem(
                value: resolution,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    resolution.icon,
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        resolution.getLocalizedName(context),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
