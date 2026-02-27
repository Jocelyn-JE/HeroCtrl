import 'package:flutter/material.dart';
import 'package:heroctrl/l10n/app_localizations.dart';
import 'package:heroctrl/screens/camera_settings/widgets/orientation_setting_card.dart';
import 'package:heroctrl/screens/camera_settings/widgets/volume_setting_card.dart';
import 'package:heroctrl/services/gopro_connection_service.dart';
import 'widgets/led_setting_card.dart';

class CameraSettingsScreen extends StatelessWidget {
  const CameraSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final password = GoProConnectionService.currentConnection!.password;
    final double bottomInset = MediaQuery.of(context).padding.bottom;
    return Scaffold(
      appBar: AppBar(title: Text(localizations.cameraSettings)),
      body: Padding(
        padding: EdgeInsets.fromLTRB(8, 0, 8, bottomInset),
        child: Column(
          children: [
            LedSettingCard(password: password),
            VolumeSettingCard(password: password),
            OrientationSettingCard(password: password),
          ],
        ),
      ),
    );
  }
}
