import 'package:flutter/material.dart';
import 'package:heroctrl/l10n/app_localizations.dart';
import 'package:heroctrl/screens/camera_settings/widgets/camera_info_card.dart';
import 'package:heroctrl/screens/camera_settings/widgets/default_mode_card.dart';
import 'package:heroctrl/screens/camera_settings/widgets/delete_all_media_card.dart';
import 'package:heroctrl/screens/camera_settings/widgets/format_sd_card_card.dart';
import 'package:heroctrl/screens/camera_settings/widgets/locate_camera_card.dart';
import 'package:heroctrl/screens/camera_settings/widgets/orientation_setting_card.dart';
import 'package:heroctrl/screens/camera_settings/widgets/video_standard_setting_card.dart';
import 'package:heroctrl/screens/camera_settings/widgets/volume_setting_card.dart';
import 'package:heroctrl/services/gopro_connection_service.dart';
import 'widgets/disconnect_card.dart';
import 'widgets/led_setting_card.dart';
import 'widgets/time_setting_card.dart';

class CameraSettingsScreen extends StatelessWidget {
  const CameraSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Camera Settings')),
        body: Center(child: Text('Localization not available')),
      );
    }
    final password = GoProConnectionService.password ?? '';
    return Scaffold(
      appBar: AppBar(title: Text(l10n.cameraSettings)),
      body: SafeArea(
        child: GoProConnectionService.isConnected
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: ListView(
                  children: [
                    DisconnectCard(password: password),
                    LedSettingCard(password: password),
                    VolumeSettingCard(password: password),
                    OrientationSettingCard(password: password),
                    DefaultModeCard(password: password),
                    VideoStandardSettingCard(password: password),
                    TimeSettingCard(password: password),
                    LocateCameraCard(password: password),
                    FormatSdCardCard(password: password),
                    DeleteAllMediaCard(password: password),
                    CameraInfoCard(password: password),
                    SizedBox(height: 8),
                  ],
                ),
              )
            : Center(child: Text('No camera connected')),
      ),
    );
  }
}
