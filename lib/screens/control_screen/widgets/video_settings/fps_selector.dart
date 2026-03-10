import 'package:flutter/material.dart';
import 'package:heroctrl/constants/gopro_recording_enums.dart';
import 'package:heroctrl/models/camera_state.dart';
import 'package:heroctrl/services/gopro_api_service.dart';
import 'package:heroctrl/utils/logger.dart';

class FPSSelector extends StatelessWidget {
  final CameraState cameraState;
  final String password;
  final Future<void> Function() onFpsChanged;
  final EdgeInsetsGeometry padding;

  const FPSSelector({
    super.key,
    required this.cameraState,
    required this.password,
    required this.onFpsChanged,
    this.padding = const EdgeInsets.all(8.0),
  });

  List<FPS> _getValidFpsOptions() {
    return VideoResolution.getSupportedFPS(
      cameraState.status.videoResolution,
      cameraState.status.videoStandard,
    );
  }

  @override
  Widget build(BuildContext context) {
    final FPS currentFps = cameraState.status.fps;
    final validFpsOptions = _getValidFpsOptions();

    // Ensure the current value exists in the valid options
    final FPS? selectedValue = validFpsOptions.contains(currentFps)
        ? currentFps
        : null;

    return validFpsOptions.length <= 1
        ? const SizedBox.shrink()
        : Padding(
            padding: padding,
            child: DropdownButton<FPS>(
              isExpanded: true,
              value: selectedValue,
              onChanged: (cameraState.isCameraOn && validFpsOptions.isNotEmpty)
                  ? (newValue) {
                      if (newValue != null) {
                        AppLogger.info(
                          'Changing FPS to ${newValue.getLocalizedName(context)}',
                        );
                        GoProApiService.setFPS(password, newValue).then((_) {
                          onFpsChanged();
                        });
                      }
                    }
                  : null,
              items: validFpsOptions
                  .map(
                    (fps) => DropdownMenuItem(
                      value: fps,
                      child: Text(fps.getLocalizedName(context)),
                    ),
                  )
                  .toList(),
            ),
          );
  }
}
