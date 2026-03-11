import 'package:flutter/material.dart';
import 'package:heroctrl/constants/gopro_action_enums.dart';
import 'package:heroctrl/models/camera_state.dart';
import 'package:heroctrl/screens/control_screen/widgets/photo_settings/burst_rate_selector.dart';
import 'package:heroctrl/screens/control_screen/widgets/photo_settings/resolution_selector.dart';
import 'package:heroctrl/screens/control_screen/widgets/photo_settings/timelapse_interval_selector.dart';

List<Widget> photoSettingsWidgets(
  CameraState cameraState,
  String password,
  Future<void> Function() onSettingChanged, {
  Axis direction = Axis.vertical,
}) {
  final isTimelapse = cameraState.status.cameraMode == CameraMode.timelapseMode;
  final isBurst = cameraState.status.cameraMode == CameraMode.burstMode;
  final spacer = const SizedBox(width: 8, height: 8);

  return [
    ResolutionSelector(
      cameraState: cameraState,
      password: password,
      onResolutionChanged: onSettingChanged,
      padding: EdgeInsets.zero,
    ),
    if (isTimelapse || isBurst) spacer,
    if (isTimelapse)
      TimelapseIntervalSelector(
        cameraState: cameraState,
        password: password,
        onIntervalChanged: onSettingChanged,
        padding: EdgeInsets.zero,
      ),
    if (isBurst)
      BurstRateSelector(
        cameraState: cameraState,
        password: password,
        onBurstRateChanged: onSettingChanged,
        padding: EdgeInsets.zero,
      ),
  ];
}
