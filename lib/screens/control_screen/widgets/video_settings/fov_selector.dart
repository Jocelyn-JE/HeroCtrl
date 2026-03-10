import 'package:flutter/material.dart';
import 'package:heroctrl/constants/gopro_recording_enums.dart';
import 'package:heroctrl/models/camera_state.dart';
import 'package:heroctrl/services/gopro_api_service.dart';
import 'package:heroctrl/utils/logger.dart';

class FOVSelector extends StatelessWidget {
  final CameraState cameraState;
  final String password;
  final Future<void> Function() onFovChanged;
  final EdgeInsetsGeometry padding;
  final bool isExpanded;

  const FOVSelector({
    super.key,
    required this.cameraState,
    required this.password,
    required this.onFovChanged,
    this.padding = const EdgeInsets.all(8.0),
    this.isExpanded = false,
  });

  /// Get the valid FOV options for the current resolution and FPS combination
  List<FOV> _getValidFovOptions() {
    final currentResolution = cameraState.status.videoResolution;
    final currentFps = cameraState.status.fps;

    return VideoResolution.getSupportedFOV(currentResolution, currentFps);
  }

  @override
  Widget build(BuildContext context) {
    final FOV currentFov = cameraState.status.fov;
    final validFovOptions = _getValidFovOptions();

    // Ensure the current value exists in the valid options
    final FOV? selectedValue = validFovOptions.contains(currentFov)
        ? currentFov
        : null;

    return validFovOptions.length <= 1
        ? const SizedBox.shrink()
        : Padding(
            padding: padding,
            child: DropdownButton<FOV>(
              isExpanded: isExpanded,
              value: selectedValue,
              onChanged: (cameraState.isCameraOn && validFovOptions.isNotEmpty)
                  ? (newValue) {
                      if (newValue != null) {
                        AppLogger.info(
                          'Changing FOV to ${newValue.getLocalizedName(context)}',
                        );
                        GoProApiService.setFOV(password, newValue).then((_) {
                          onFovChanged();
                        });
                      }
                    }
                  : null,
              items: validFovOptions
                  .map(
                    (fov) => DropdownMenuItem(
                      value: fov,
                      child: Text(fov.getLocalizedName(context)),
                    ),
                  )
                  .toList(),
            ),
          );
  }
}
