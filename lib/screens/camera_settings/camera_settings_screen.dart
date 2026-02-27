import 'package:flutter/material.dart';
import 'package:heroctrl/l10n/app_localizations.dart';
import 'package:heroctrl/screens/camera_settings/widgets/orientation_setting_card.dart';
import 'package:heroctrl/screens/camera_settings/widgets/video_mode_setting_card.dart';
import 'package:heroctrl/screens/camera_settings/widgets/volume_setting_card.dart';
import 'package:heroctrl/services/gopro_connection_service.dart';
import 'widgets/led_setting_card.dart';
import 'widgets/time_setting_card.dart';

class CameraSettingsScreen extends StatelessWidget {
  const CameraSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final password = GoProConnectionService.currentConnection!.password;
    return Scaffold(
      appBar: AppBar(title: Text(localizations.cameraSettings)),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: ListView(
          children: [
            LedSettingCard(password: password),
            VolumeSettingCard(password: password),
            OrientationSettingCard(password: password),
            VideoModeSettingCard(password: password),
            TimeSettingCard(password: password),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
