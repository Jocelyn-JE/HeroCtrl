import 'package:flutter/material.dart';
import 'package:heroctrl/models/camera_state.dart';
import 'package:heroctrl/screens/control_screen/widgets/camera_mode_carousel.dart';
import 'package:heroctrl/screens/control_screen/widgets/media_count_display.dart';
import 'package:heroctrl/screens/control_screen/widgets/settings_cards_panel.dart';

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
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SettingsCardsPanel(
                    cameraState: cameraState!,
                    password: password,
                    onSettingChanged: onSettingChanged,
                    videoPhotoDirection: Axis.vertical,
                  ),
                  MediaCountDisplay(cameraState: cameraState),
                  CameraModeCarousel(
                    cameraState: cameraState!,
                    password: password,
                    onStatusUpdated: onSettingChanged,
                  ),
                ],
              ),
            ),
          previewArea,
        ],
      ),
    );
  }
}
