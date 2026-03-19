import 'package:flutter/material.dart';
import 'package:heroctrl/gopro_settings/actions/camera_mode.dart';
import 'package:heroctrl/l10n/app_localizations.dart';
import 'package:heroctrl/gopro_settings/recording/fps.dart';
import 'package:heroctrl/gopro_settings/recording/low_light.dart';
import 'package:heroctrl/gopro_settings/recording/spot_meter.dart';
import 'package:heroctrl/models/camera_state.dart';
import 'package:heroctrl/services/gopro_api_service.dart';
import 'package:heroctrl/utils/logger.dart';

class RecordingSettingsCard extends StatelessWidget {
  final CameraState cameraState;
  final String password;
  final Future<void> Function() onSettingChanged;

  const RecordingSettingsCard({
    super.key,
    required this.cameraState,
    required this.password,
    required this.onSettingChanged,
  });

  // API docs note low light only works above 30fps.
  bool _isLowLightSupportedAtCurrentFps() {
    return switch (cameraState.status.fps) {
      Fps.fps48 ||
      Fps.fps50 ||
      Fps.fps60 ||
      Fps.fps100 ||
      Fps.fps120 ||
      Fps.fps240 => true,
      Fps() => false,
    };
  }

  bool get _showLowLight {
    if (cameraState.status.lowLightMode == LowLight.on) {
      return true;
    }

    if (cameraState.status.cameraMode != CameraMode.videoMode) {
      return false;
    }

    return _isLowLightSupportedAtCurrentFps();
  }

  Future<void> _setSpotMeter(bool enabled) async {
    try {
      await GoProApiService.setSpotMeter(
        password,
        enabled ? SpotMeter.on : SpotMeter.off,
      );
      await onSettingChanged();
    } catch (error, stackTrace) {
      AppLogger.error('Error setting spot meter', error, stackTrace);
    }
  }

  Future<void> _setLowLight(bool enabled) async {
    try {
      await GoProApiService.setLowLight(
        password,
        enabled ? LowLight.on : LowLight.off,
      );
      await onSettingChanged();
    } catch (error, stackTrace) {
      AppLogger.error('Error setting low light mode', error, stackTrace);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (l10n == null) return const SizedBox.shrink();
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SwitchListTile(
            dense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
            title: Text(l10n.spotMeter),
            subtitle: Text(
              cameraState.status.spotMeter.getLocalizedName(context),
            ),
            value: cameraState.status.spotMeter == SpotMeter.on,
            onChanged: cameraState.isCameraOn ? _setSpotMeter : null,
          ),
          if (_showLowLight) const Divider(height: 0),
          if (_showLowLight)
            SwitchListTile(
              dense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
              title: Text(l10n.lowLight),
              subtitle: Text(
                cameraState.status.lowLightMode.getLocalizedName(context),
              ),
              value: cameraState.status.lowLightMode == LowLight.on,
              onChanged: cameraState.isCameraOn ? _setLowLight : null,
            ),
        ],
      ),
    );
  }
}
