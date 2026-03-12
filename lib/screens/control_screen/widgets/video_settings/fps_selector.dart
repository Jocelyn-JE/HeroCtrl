import 'package:flutter/material.dart';
import 'package:heroctrl/constants/gopro_protune_enums.dart';
import 'package:heroctrl/constants/gopro_recording_enums.dart';
import 'package:heroctrl/models/camera_state.dart';
import 'package:heroctrl/services/gopro_api_service.dart';
import 'package:heroctrl/utils/logger.dart';

class FpsSelector extends StatelessWidget {
  final CameraState cameraState;
  final String password;
  final Future<void> Function() onFpsChanged;
  final EdgeInsetsGeometry padding;

  const FpsSelector({
    super.key,
    required this.cameraState,
    required this.password,
    required this.onFpsChanged,
    this.padding = const EdgeInsets.all(8.0),
  });

  static List<Fps> getValidFpsOptionsFor(CameraState cameraState) {
    final resolution = cameraState.status.videoResolution;
    final standard = cameraState.status.videoStandard;
    final isProtuneOn = cameraState.status.protuneStatus == ProTune.on;

    if (!isProtuneOn) {
      return VideoResolution.getSupportedFps(resolution, standard);
    }

    final protuneResolution = ProTuneVideoResolution.fromVideoResolution(
      resolution,
    );
    return ProTuneVideoResolution.getSupportedFps(protuneResolution, standard);
  }

  List<Fps> _getValidFpsOptions() {
    return getValidFpsOptionsFor(cameraState);
  }

  @override
  Widget build(BuildContext context) {
    final Fps currentFps = cameraState.status.fps;
    final validFpsOptions = _getValidFpsOptions();

    // Ensure the current value exists in the valid options
    final Fps? selectedValue = validFpsOptions.contains(currentFps)
        ? currentFps
        : null;

    return validFpsOptions.length <= 1
        ? const SizedBox.shrink()
        : Padding(
            padding: padding,
            child: DropdownButton<Fps>(
              isExpanded: true,
              value: selectedValue,
              onChanged: (cameraState.isCameraOn && validFpsOptions.isNotEmpty)
                  ? (newValue) {
                      if (newValue != null) {
                        AppLogger.info(
                          'Changing FPS to ${newValue.getLocalizedName(context)}',
                        );
                        GoProApiService.setFps(password, newValue).then((_) {
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
