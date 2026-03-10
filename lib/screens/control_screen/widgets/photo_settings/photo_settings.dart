import 'package:flutter/material.dart';
import 'package:heroctrl/models/camera_state.dart';
import 'package:heroctrl/screens/control_screen/widgets/photo_settings/resolution_selector.dart';

List<Widget> photoSettingsWidgets(
  CameraState cameraState,
  String password,
  Future<void> Function() onSettingChanged, {
  Axis direction = Axis.vertical,
}) {
  return [
    ResolutionSelector(
      cameraState: cameraState,
      password: password,
      onResolutionChanged: onSettingChanged,
      padding: EdgeInsets.zero,
    ),
  ];
}
