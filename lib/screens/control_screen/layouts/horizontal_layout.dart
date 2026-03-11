import 'package:flutter/material.dart';
import 'package:heroctrl/constants/gopro_action_enums.dart';
import 'package:heroctrl/models/camera_state.dart';
import 'package:heroctrl/screens/control_screen/widgets/camera_mode_carousel.dart';
import 'package:heroctrl/screens/control_screen/widgets/media_count_display.dart';
import 'package:heroctrl/screens/control_screen/widgets/photo_settings/photo_settings.dart';
import 'package:heroctrl/screens/control_screen/widgets/video_settings/video_settings.dart';
import 'package:heroctrl/utils/camera_state_conditions.dart';

class HorizontalLayout extends StatelessWidget {
  final Widget previewArea;
  final CameraState? cameraState;
  final String password;
  final Future<void> Function() onSettingChanged;

  const HorizontalLayout({
    super.key,
    required this.previewArea,
    required this.cameraState,
    required this.password,
    required this.onSettingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 8.0,
        children: [
          if (cameraState != null)
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (CameraStateConditions.isRecording(cameraState))
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          children: switch (cameraState!.status.cameraMode) {
                            CameraMode.videoMode => videoSettingsWidgets(
                              cameraState!,
                              password,
                              onSettingChanged,
                              direction: Axis.vertical,
                            ),
                            CameraMode.photoMode ||
                            CameraMode.burstMode ||
                            CameraMode.timelapseMode => photoSettingsWidgets(
                              cameraState!,
                              password,
                              onSettingChanged,
                              direction: Axis.vertical,
                            ),
                            CameraMode() => [],
                          },
                        ),
                      ),
                    ),
                  const Spacer(),
                  MediaCountDisplay(cameraState: cameraState),
                  CameraModeCarousel(
                    cameraState: cameraState!,
                    password: password,
                    onStatusUpdated: onSettingChanged,
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
