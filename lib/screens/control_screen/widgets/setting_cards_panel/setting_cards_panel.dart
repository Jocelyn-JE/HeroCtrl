import 'package:flutter/material.dart';
import 'package:heroctrl/gopro_settings/actions/camera_mode.dart';
import 'package:heroctrl/gopro_settings/protune/pro_tune.dart';
import 'package:heroctrl/models/camera_state.dart';
import 'package:heroctrl/screens/control_screen/widgets/setting_cards_panel/cards/photo.dart';
import 'package:heroctrl/screens/control_screen/widgets/setting_cards_panel/cards/protune.dart';
import 'package:heroctrl/screens/control_screen/widgets/setting_cards_panel/cards/recording.dart';
import 'package:heroctrl/screens/control_screen/widgets/setting_cards_panel/cards/video.dart';
import 'package:heroctrl/utils/camera_state_conditions.dart';

/// A reusable panel that displays all settings cards in a scrollable column.
/// Used by both horizontal and vertical layouts.
class SettingCardsPanel extends StatelessWidget {
  final CameraState cameraState;
  final String password;
  final Future<void> Function() onSettingChanged;

  const SettingCardsPanel({
    super.key,
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
              switch (cameraState.status.cameraMode) {
                CameraMode.videoMode => VideoSettingsCard(
                  cameraState: cameraState,
                  password: password,
                  onSettingChanged: onSettingChanged,
                ),
                CameraMode.photoMode ||
                CameraMode.burstMode ||
                CameraMode.timelapseMode => PhotoSettingsCard(
                  cameraState: cameraState,
                  password: password,
                  onSettingChanged: onSettingChanged,
                ),
                CameraMode() => const SizedBox.shrink(),
              },
            if (_showSettingCards)
              RecordingSettingsCard(
                cameraState: cameraState,
                password: password,
                onSettingChanged: onSettingChanged,
              ),
            if (_showSettingCards &&
                cameraState.status.protuneStatus == ProTune.on)
              ProTuneSettingsCard(
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
