import 'package:flutter/material.dart';
import 'package:heroctrl/constants/gopro_endpoints.dart';
import 'package:heroctrl/models/camera_state.dart';
import 'package:heroctrl/utils/logger.dart';

class FPSSelector extends StatelessWidget {
  final CameraState cameraState;
  final String password;
  final Future<void> Function(FPS) onFpsChanged;

  const FPSSelector({
    super.key,
    required this.cameraState,
    required this.password,
    required this.onFpsChanged,
  });

  /// Get the valid FPS options for the current resolution and video mode.
  /// This is the intersection of:
  /// - FPS supported by the current resolution
  /// - FPS supported by the current video mode (NTSC/PAL)
  List<FPS> _getValidFpsOptions() {
    final currentResolution = cameraState.status.videoResolution;
    final currentVideoMode = cameraState.status.videoMode;

    // Get FPS supported by the current resolution
    final fpsForResolution =
        VideoResolution.supportedFPS[currentResolution] ?? [];

    // Get FPS supported by the current video mode
    final fpsForVideoMode =
        VideoModes.videoModesFrameRates[currentVideoMode] ?? [];

    // Find the intersection
    return fpsForResolution
        .where((fps) => fpsForVideoMode.contains(fps))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final FPS currentFps = cameraState.status.fps;
    final validFpsOptions = _getValidFpsOptions();

    // Ensure the current value exists in the valid options
    final FPS? selectedValue = validFpsOptions.contains(currentFps)
        ? currentFps
        : null;

    return Container(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButton<FPS>(
        value: selectedValue,
        onChanged: (cameraState.isCameraOn && validFpsOptions.isNotEmpty)
            ? (newValue) {
                if (newValue != null) {
                  AppLogger.info(
                    'Changing FPS to ${newValue.getLocalizedName(context)}',
                  );
                  onFpsChanged(newValue);
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
