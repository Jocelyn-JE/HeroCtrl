import 'package:flutter/material.dart';
import 'package:heroctrl/constants/gopro_endpoints.dart';
import 'package:heroctrl/models/camera_state.dart';
import 'package:heroctrl/services/gopro_api_service.dart';
import 'package:heroctrl/utils/logger.dart';

class ResolutionSelector extends StatelessWidget {
  final CameraState cameraState;
  final String password;

  const ResolutionSelector({
    super.key,
    required this.cameraState,
    required this.password,
  });

  @override
  Widget build(BuildContext context) {
    final String currentResolution = cameraState.status.videoResolution;

    // Ensure the current value exists in the dropdown items
    final String? selectedValue =
        VideoResolution.videoResolutions.contains(currentResolution)
        ? currentResolution
        : null;

    return Container(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButton<String>(
        value: selectedValue,
        onChanged: (cameraState.isCameraOn)
            ? (newValue) {
                AppLogger.info(
                  'Changing video resolution to ${VideoResolution.getLocalizedName(context, newValue ?? '')}',
                );
                if (newValue != null) {
                  GoProApiService.setVideoResolution(password, newValue);
                }
              }
            : null,
        items: VideoResolution.videoResolutions
            .map(
              (resolution) => DropdownMenuItem(
                value: resolution,
                child: Text(
                  VideoResolution.getLocalizedName(context, resolution),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
