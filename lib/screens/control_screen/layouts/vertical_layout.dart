import 'package:flutter/material.dart';
import 'package:heroctrl/constants/gopro_recording_enums.dart';
import 'package:heroctrl/constants/gopro_system_enums.dart';
import 'package:heroctrl/models/camera_state.dart';
import 'package:heroctrl/screens/control_screen/widgets/video_settings/resolution_selector.dart';
import 'package:heroctrl/screens/control_screen/widgets/video_settings/fps_selector.dart';
import 'package:heroctrl/screens/control_screen/widgets/video_settings/fov_selector.dart';
import 'package:heroctrl/screens/control_screen/widgets/camera_mode_carousel.dart';
import 'package:heroctrl/utils/camera_state_conditions.dart';

class VerticalLayout extends StatelessWidget {
  final Widget previewArea;
  final CameraState? cameraState;
  final String password;
  final Future<void> Function() onSettingChanged;

  const VerticalLayout({
    super.key,
    required this.previewArea,
    required this.cameraState,
    required this.password,
    required this.onSettingChanged,
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

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        previewArea,
        if (cameraState != null)
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                if (!cameraState!.status.shutterStatus)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (showVideoRes)
                          Expanded(
                            child: ResolutionSelector(
                              cameraState: cameraState!,
                              password: password,
                              onResolutionChanged: onSettingChanged,
                              padding: EdgeInsets.zero,
                            ),
                          ),
                        if (showFps || showFov) const SizedBox(width: 8),
                        if (showFps)
                          FPSSelector(
                            cameraState: cameraState!,
                            password: password,
                            onFpsChanged: onSettingChanged,
                            padding: EdgeInsets.zero,
                          ),
                        if (showFps && showFov) const SizedBox(width: 8),
                        if (showFov)
                          FOVSelector(
                            cameraState: cameraState!,
                            password: password,
                            onFovChanged: onSettingChanged,
                            padding: EdgeInsets.zero,
                          ),
                      ],
                    ),
                  ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: CameraModeCarousel(
                    cameraState: cameraState!,
                    password: password,
                    onStatusUpdated: onSettingChanged,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
