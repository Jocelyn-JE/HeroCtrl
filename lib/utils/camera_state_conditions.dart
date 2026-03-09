import 'package:flutter/material.dart';
import 'package:heroctrl/constants/gopro_action_enums.dart';
import 'package:heroctrl/models/camera_state.dart';

class CameraStateConditions {
  // Static helper methods for use without instance
  static bool isCameraOn(CameraState? state) => state?.isCameraOn == true;

  static bool isPreviewOn(CameraState? state) => state?.isPreviewOn == true;

  static bool isRecording(CameraState? state) =>
      state?.status.shutterStatus == true &&
      (state?.status.cameraMode == CameraMode.videoMode ||
          state?.status.cameraMode == CameraMode.timelapseMode);

  static bool isShutterDown(CameraState? state) =>
      state?.status.shutterStatus == true;

  static bool isInSettingsMode(CameraState? state) =>
      state?.status.cameraMode == CameraMode.settings;

  static bool isInPhotoOrBurstMode(CameraState? state) =>
      state?.status.cameraMode == CameraMode.photoMode ||
      state?.status.cameraMode == CameraMode.burstMode;

  static bool isInPhotoMode(CameraState? state) =>
      state?.status.cameraMode == CameraMode.photoMode;

  static bool isInVideoOrTimelapseMode(CameraState? state) =>
      state?.status.cameraMode == CameraMode.videoMode ||
      state?.status.cameraMode == CameraMode.timelapseMode;

  static bool isInVideoMode(CameraState? state) =>
      state?.status.cameraMode == CameraMode.videoMode;

  static bool isInTimelapseMode(CameraState? state) =>
      state?.status.cameraMode == CameraMode.timelapseMode;
}

bool isLandscape(BuildContext context) =>
    MediaQuery.of(context).orientation == Orientation.landscape;
