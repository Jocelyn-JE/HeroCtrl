import 'package:flutter/material.dart';
import 'package:heroctrl/constants/gopro_recording_enums.dart';
import 'package:heroctrl/constants/gopro_system_enums.dart';
import 'package:heroctrl/models/camera_state.dart';
import 'package:heroctrl/screens/control_screen/widgets/resolution_selector.dart';
import 'package:heroctrl/screens/control_screen/widgets/fps_selector.dart';
import 'package:heroctrl/screens/control_screen/widgets/fov_selector.dart';
import 'package:heroctrl/utils/camera_state_conditions.dart';

class HorizontalLayout extends StatelessWidget {
  final Widget previewArea;
  final CameraState? cameraState;
  final String password;
  final Future<void> Function(VideoResolution) onResolutionChanged;
  final Future<void> Function(FPS) onFpsChanged;
  final Future<void> Function(FOV) onFovChanged;

  const HorizontalLayout({
    super.key,
    required this.previewArea,
    required this.cameraState,
    required this.password,
    required this.onResolutionChanged,
    required this.onFpsChanged,
    required this.onFovChanged,
  });

  @override
  Widget build(BuildContext context) {
    final currentState = cameraState;

    final showFps =
        currentState != null &&
            CameraStateConditions.isInVideoMode(currentState)
        ? (() {
            final currentResolution = currentState.status.videoResolution;
            final currentVideoStandard = currentState.status.videoStandard;
            final fpsForResolution =
                VideoResolution.supportedFPS[currentResolution] ?? [];
            final fpsForVideoStandard =
                VideoStandard.videoStandardFrameRates[currentVideoStandard] ??
                [];
            final validFpsOptions = fpsForResolution
                .where((fps) => fpsForVideoStandard.contains(fps))
                .toList();
            return validFpsOptions.length > 1;
          })()
        : false;

    final showFov =
        currentState != null &&
            CameraStateConditions.isInVideoMode(currentState)
        ? VideoResolution.getSupportedFOV(
                currentState.status.videoResolution,
                currentState.status.fps,
              ).length >
              1
        : false;

    final showVideoRes =
        currentState != null &&
        CameraStateConditions.isInVideoMode(currentState);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 8.0,
        children: [
          if (cameraState != null && !cameraState!.status.shutterStatus)
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (showVideoRes)
                    ResolutionSelector(
                      cameraState: cameraState!,
                      password: password,
                      onResolutionChanged: onResolutionChanged,
                      padding: EdgeInsets.zero,
                    ),
                  if (showFps || showFov) const SizedBox(height: 8),
                  if (showFps)
                    FPSSelector(
                      cameraState: cameraState!,
                      password: password,
                      onFpsChanged: onFpsChanged,
                      padding: EdgeInsets.zero,
                      isExpanded: true,
                    ),
                  if (showFps && showFov) const SizedBox(height: 8),
                  if (showFov)
                    FOVSelector(
                      cameraState: cameraState!,
                      password: password,
                      onFovChanged: onFovChanged,
                      padding: EdgeInsets.zero,
                      isExpanded: true,
                    ),
                ],
              ),
            ),
          Expanded(flex: 0, child: previewArea),
        ],
      ),
    );
  }
}
