import 'package:flutter/material.dart';
import 'package:heroctrl/gopro_settings/actions/camera_mode.dart';
import 'package:heroctrl/gopro_settings/protune/pro_tune.dart';
import 'package:heroctrl/models/camera_state.dart';
import 'package:heroctrl/screens/control_screen/widgets/camera_mode_carousel.dart';
import 'package:heroctrl/screens/control_screen/widgets/media_count_display.dart';
import 'package:heroctrl/screens/control_screen/widgets/photo_settings/photo_settings.dart';
import 'package:heroctrl/screens/control_screen/widgets/protune_options_card.dart';
import 'package:heroctrl/screens/control_screen/widgets/recording_options_card.dart';
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

  bool _showsModeSettings(CameraState state) {
    return switch (state.status.cameraMode) {
      CameraMode.videoMode ||
      CameraMode.photoMode ||
      CameraMode.burstMode ||
      CameraMode.timelapseMode => true,
      CameraMode() => false,
    };
  }

  @override
  Widget build(BuildContext context) {
    final showSettingCards =
        cameraState != null &&
        !CameraStateConditions.isRecording(cameraState) &&
        _showsModeSettings(cameraState!);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        previewArea,
        if (cameraState != null)
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (showSettingCards)
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: Column(
                                children: switch (cameraState!
                                    .status
                                    .cameraMode) {
                                  CameraMode.videoMode => videoSettingsWidgets(
                                    cameraState!,
                                    password,
                                    onSettingChanged,
                                    direction: Axis.horizontal,
                                  ),
                                  CameraMode.photoMode ||
                                  CameraMode.burstMode ||
                                  CameraMode.timelapseMode =>
                                    photoSettingsWidgets(
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
                        if (showSettingCards)
                          RecordingOptionsCard(
                            cameraState: cameraState!,
                            password: password,
                            onSettingChanged: onSettingChanged,
                          ),
                        if (showSettingCards &&
                            cameraState!.status.protuneStatus == ProTune.on)
                          ProTuneOptionsCard(
                            cameraState: cameraState!,
                            password: password,
                            onSettingChanged: onSettingChanged,
                          ),
                      ],
                    ),
                  ),
                ),
                MediaCountDisplay(cameraState: cameraState),
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
