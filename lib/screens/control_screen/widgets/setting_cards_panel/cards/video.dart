import 'package:flutter/material.dart';
import 'package:heroctrl/gopro_settings/protune/pro_tune.dart';
import 'package:heroctrl/l10n/app_localizations.dart';
import 'package:heroctrl/gopro_settings/protune/pro_tune_video_resolution.dart';
import 'package:heroctrl/gopro_settings/recording/fov.dart';
import 'package:heroctrl/gopro_settings/recording/fps.dart';
import 'package:heroctrl/gopro_settings/recording/video_resolution.dart';
import 'package:heroctrl/models/camera_state.dart';
import 'package:heroctrl/services/gopro_api_service.dart';
import 'package:heroctrl/utils/camera_state_conditions.dart';
import 'package:heroctrl/utils/logger.dart';

class VideoSettingsCard extends StatelessWidget {
  final CameraState cameraState;
  final String password;
  final Future<void> Function() onSettingChanged;

  const VideoSettingsCard({
    super.key,
    required this.cameraState,
    required this.password,
    required this.onSettingChanged,
  });

  Future<void> _setVideoResolution(VideoResolution option) async {
    try {
      await GoProApiService.setVideoResolution(password, option);
      await onSettingChanged();
    } catch (error, stackTrace) {
      AppLogger.error('Error setting video resolution', error, stackTrace);
    }
  }

  Future<void> _setFps(Fps option) async {
    try {
      await GoProApiService.setFps(password, option);
      await onSettingChanged();
    } catch (error, stackTrace) {
      AppLogger.error('Error setting FPS', error, stackTrace);
    }
  }

  Future<void> _setFov(Fov option) async {
    try {
      await GoProApiService.setFov(password, option);
      await onSettingChanged();
    } catch (error, stackTrace) {
      AppLogger.error('Error setting FOV', error, stackTrace);
    }
  }

  Widget _buildResolutionSelector(BuildContext context) {
    final VideoResolution currentResolution =
        cameraState.status.videoResolution;
    final isProtuneOn = cameraState.status.protuneStatus == ProTune.on;
    final validResolutionOptions = !isProtuneOn
        ? VideoResolution.all
        : ProTuneVideoResolution.supportedVideoResolutions;

    final VideoResolution? selectedValue =
        validResolutionOptions.contains(currentResolution)
        ? currentResolution
        : null;
    final l10n = AppLocalizations.of(context);

    if (l10n == null) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.videoResolution),
        DropdownButton<VideoResolution>(
          isExpanded: true,
          value: selectedValue,
          onChanged: cameraState.isCameraOn
              ? (newValue) {
                  if (newValue != null) {
                    _setVideoResolution(newValue);
                  }
                }
              : null,
          items: validResolutionOptions
              .map(
                (resolution) => DropdownMenuItem(
                  value: resolution,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      resolution.icon,
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          resolution.getLocalizedName(context),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildFpsSelector(BuildContext context) {
    final Fps currentFps = cameraState.status.fps;
    final validFpsOptions = _getValidFpsOptions();

    final Fps? selectedValue = validFpsOptions.contains(currentFps)
        ? currentFps
        : null;
    final l10n = AppLocalizations.of(context);

    if (l10n == null) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.fps),
        DropdownButton<Fps>(
          isExpanded: true,
          value: selectedValue,
          onChanged: (cameraState.isCameraOn && validFpsOptions.isNotEmpty)
              ? (newValue) {
                  if (newValue != null) {
                    _setFps(newValue);
                  }
                }
              : null,
          items: validFpsOptions
              .map(
                (fps) => DropdownMenuItem(
                  value: fps,
                  child: Text(fps.getLocalizedName(context)),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildFovSelector(BuildContext context) {
    final Fov currentFov = cameraState.status.fov;
    final validFovOptions = _getValidFovOptions();

    final Fov? selectedValue = validFovOptions.contains(currentFov)
        ? currentFov
        : null;
    final l10n = AppLocalizations.of(context);

    if (l10n == null) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.zoom),
        DropdownButton<Fov>(
          isExpanded: true,
          value: selectedValue,
          onChanged: (cameraState.isCameraOn && validFovOptions.isNotEmpty)
              ? (newValue) {
                  if (newValue != null) {
                    _setFov(newValue);
                  }
                }
              : null,
          items: validFovOptions
              .map(
                (fov) => DropdownMenuItem(
                  value: fov,
                  child: Text(fov.getLocalizedName(context)),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  List<Fps> _getValidFpsOptions() {
    final resolution = cameraState.status.videoResolution;
    final standard = cameraState.status.videoStandard;
    final isProtuneOn = cameraState.status.protuneStatus == ProTune.on;

    if (!isProtuneOn) {
      return VideoResolution.getSupportedFps(resolution, standard);
    }

    final protuneResolution = ProTuneVideoResolution.fromVideoResolution(
      resolution,
    );
    return ProTuneVideoResolution.getSupportedFps(protuneResolution, standard);
  }

  List<Fov> _getValidFovOptions() {
    final currentResolution = cameraState.status.videoResolution;
    final currentFps = cameraState.status.fps;

    return VideoResolution.getSupportedFov(currentResolution, currentFps);
  }

  @override
  Widget build(BuildContext context) {
    final showFps = CameraStateConditions.isInVideoMode(cameraState)
        ? _getValidFpsOptions().length > 1
        : false;

    final showFov = CameraStateConditions.isInVideoMode(cameraState)
        ? _getValidFovOptions().length > 1
        : false;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildResolutionSelector(context),
            if (showFps || showFov) const SizedBox(height: 12),
            if (showFps) _buildFpsSelector(context),
            if (showFps && showFov) const SizedBox(height: 12),
            if (showFov) _buildFovSelector(context),
          ],
        ),
      ),
    );
  }
}
