import 'package:flutter/material.dart';
import 'package:heroctrl/gopro_settings/actions/camera_mode.dart';
import 'package:heroctrl/gopro_settings/protune/pro_tune.dart';
import 'package:heroctrl/models/camera_state.dart';
import 'package:heroctrl/screens/control_screen/widgets/photo_settings/photo_settings.dart';
import 'package:heroctrl/screens/control_screen/widgets/protune_options_card.dart';
import 'package:heroctrl/screens/control_screen/widgets/recording_options_card.dart';
import 'package:heroctrl/screens/control_screen/widgets/video_settings/video_settings.dart';
import 'package:heroctrl/utils/camera_state_conditions.dart';

/// A reusable panel that displays all settings cards in a scrollable column.
/// Used by both horizontal and vertical layouts.
class SettingsCardsPanel extends StatelessWidget {
  final CameraState cameraState;
  final String password;
  final Future<void> Function() onSettingChanged;
  final Axis videoPhotoDirection;

  const SettingsCardsPanel({
    super.key,
    required this.cameraState,
    required this.password,
    required this.onSettingChanged,
    required this.videoPhotoDirection,
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

  bool get _showSettingCards =>
      !CameraStateConditions.isRecording(cameraState) &&
      _showsModeSettings(cameraState);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_showSettingCards)
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: switch (cameraState.status.cameraMode) {
                      CameraMode.videoMode => videoSettingsWidgets(
                        cameraState,
                        password,
                        onSettingChanged,
                        direction: videoPhotoDirection,
                      ),
                      CameraMode.photoMode ||
                      CameraMode.burstMode ||
                      CameraMode.timelapseMode => photoSettingsWidgets(
                        cameraState,
                        password,
                        onSettingChanged,
                        direction: videoPhotoDirection,
                      ),
                      CameraMode() => [],
                    },
                  ),
                ),
              ),
            if (_showSettingCards)
              RecordingOptionsCard(
                cameraState: cameraState,
                password: password,
                onSettingChanged: onSettingChanged,
              ),
            if (_showSettingCards &&
                cameraState.status.protuneStatus == ProTune.on)
              ProTuneOptionsCard(
                cameraState: cameraState,
                password: password,
                onSettingChanged: onSettingChanged,
              ),
          ],
        ),
      ),
    );
  }
}
