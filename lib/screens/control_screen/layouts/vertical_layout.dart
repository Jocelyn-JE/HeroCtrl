import 'package:flutter/material.dart';
import 'package:heroctrl/constants/gopro_action_enums.dart';
import 'package:heroctrl/models/camera_state.dart';
import 'package:heroctrl/screens/control_screen/widgets/camera_mode_carousel.dart';
import 'package:heroctrl/screens/control_screen/widgets/photo_settings/photo_settings.dart';
import 'package:heroctrl/screens/control_screen/widgets/video_settings/video_settings.dart';
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        previewArea,
        if (cameraState != null)
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                if (!CameraStateConditions.isRecording(cameraState))
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        children: switch (cameraState!.status.cameraMode) {
                          CameraMode.videoMode => videoSettingsWidgets(
                            cameraState!,
                            password,
                            onSettingChanged,
                            direction: Axis.horizontal,
                          ),
                          CameraMode.photoMode => photoSettingsWidgets(
                            cameraState!,
                            password,
                            onSettingChanged,
                            direction: Axis.horizontal,
                          ),
                          CameraMode() => [],
                        },
                      ),
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
