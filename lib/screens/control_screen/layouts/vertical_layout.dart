import 'package:flutter/material.dart';
import 'package:heroctrl/models/camera_state.dart';
import 'package:heroctrl/screens/control_screen/widgets/camera_mode_carousel.dart';
import 'package:heroctrl/screens/control_screen/widgets/media_count_display.dart';
import 'package:heroctrl/screens/control_screen/widgets/settings_cards_panel.dart';

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
                SettingsCardsPanel(
                  cameraState: cameraState!,
                  password: password,
                  onSettingChanged: onSettingChanged,
                  videoPhotoDirection: Axis.horizontal,
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
