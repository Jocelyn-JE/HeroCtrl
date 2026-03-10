import 'package:flutter/material.dart';
import 'package:heroctrl/constants/gopro_recording_enums.dart';
import 'package:heroctrl/constants/gopro_system_enums.dart';
import 'package:heroctrl/models/camera_state.dart';
import 'package:heroctrl/screens/control_screen/widgets/video_settings/fov_selector.dart';
import 'package:heroctrl/screens/control_screen/widgets/video_settings/fps_selector.dart';
import 'package:heroctrl/screens/control_screen/widgets/video_settings/resolution_selector.dart';
import 'package:heroctrl/utils/camera_state_conditions.dart';

List<Widget> videoSettingsWidgets(
  CameraState cameraState,
  String password,
  Future<void> Function() onSettingChanged, {
  Axis direction = Axis.vertical,
}) {
  bool showFps = CameraStateConditions.isInVideoMode(cameraState)
      ? (() {
          final currentResolution = cameraState.status.videoResolution;
          final currentVideoStandard = cameraState.status.videoStandard;
          final fpsForResolution =
              VideoResolution.supportedFPS[currentResolution] ?? [];
          final fpsForVideoStandard =
              VideoStandard.videoStandardFrameRates[currentVideoStandard] ?? [];
          final validFpsOptions = fpsForResolution
              .where((fps) => fpsForVideoStandard.contains(fps))
              .toList();
          return validFpsOptions.length > 1;
        })()
      : false;

  bool showFov = CameraStateConditions.isInVideoMode(cameraState)
      ? VideoResolution.getSupportedFOV(
              cameraState.status.videoResolution,
              cameraState.status.fps,
            ).length >
            1
      : false;

  final spacer = const SizedBox(width: 8, height: 8);

  return [
    ResolutionSelector(
      cameraState: cameraState,
      onResolutionChanged: onSettingChanged,
      password: password,
      padding: EdgeInsets.zero,
    ),

    if ((showFps || showFov)) spacer,
    if (showFps)
      FPSSelector(
        cameraState: cameraState,
        onFpsChanged: onSettingChanged,
        padding: EdgeInsets.zero,
        password: password,
      ),

    if (showFps && showFov) spacer,
    if (showFov)
      FOVSelector(
        cameraState: cameraState,
        onFovChanged: onSettingChanged,
        padding: EdgeInsets.zero,
        password: password,
      ),
  ];
}
