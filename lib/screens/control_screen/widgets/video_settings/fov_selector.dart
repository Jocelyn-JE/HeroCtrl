import 'package:flutter/material.dart';
import 'package:heroctrl/gopro_settings/recording.dart';
import 'package:heroctrl/models/camera_state.dart';
import 'package:heroctrl/services/gopro_api_service.dart';
import 'package:heroctrl/utils/logger.dart';

class FovSelector extends StatelessWidget {
  final CameraState cameraState;
  final String password;
  final Future<void> Function() onFovChanged;
  final EdgeInsetsGeometry padding;

  const FovSelector({
    super.key,
    required this.cameraState,
    required this.password,
    required this.onFovChanged,
    this.padding = const EdgeInsets.all(8.0),
  });

  /// Get the valid FOV options for the current resolution and FPS combination
  List<Fov> _getValidFovOptions() {
    final currentResolution = cameraState.status.videoResolution;
    final currentFps = cameraState.status.fps;

    return VideoResolution.getSupportedFov(currentResolution, currentFps);
  }

  @override
  Widget build(BuildContext context) {
    final Fov currentFov = cameraState.status.fov;
    final validFovOptions = _getValidFovOptions();

    // Ensure the current value exists in the valid options
    final Fov? selectedValue = validFovOptions.contains(currentFov)
        ? currentFov
        : null;

    return validFovOptions.length <= 1
        ? const SizedBox.shrink()
        : Padding(
            padding: padding,
            child: DropdownButton<Fov>(
              isExpanded: true,
              value: selectedValue,
              onChanged: (cameraState.isCameraOn && validFovOptions.isNotEmpty)
                  ? (newValue) {
                      if (newValue != null) {
                        AppLogger.info(
                          'Changing FOV to ${newValue.getLocalizedName(context)}',
                        );
                        GoProApiService.setFov(password, newValue).then((_) {
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
