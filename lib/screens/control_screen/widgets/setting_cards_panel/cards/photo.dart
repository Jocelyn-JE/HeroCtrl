import 'package:flutter/material.dart';
import 'package:heroctrl/gopro_settings/actions/camera_mode.dart';
import 'package:heroctrl/gopro_settings/photo/burst_rate.dart';
import 'package:heroctrl/gopro_settings/photo/photo_resolution.dart';
import 'package:heroctrl/gopro_settings/photo/timelapse_interval.dart';
import 'package:heroctrl/models/camera_state.dart';
import 'package:heroctrl/services/gopro_api_service.dart';
import 'package:heroctrl/utils/logger.dart';

class PhotoSettingsCard extends StatelessWidget {
  final CameraState cameraState;
  final String password;
  final Future<void> Function() onSettingChanged;

  const PhotoSettingsCard({
    super.key,
    required this.cameraState,
    required this.password,
    required this.onSettingChanged,
  });

  Future<void> _setPhotoResolution(PhotoResolution option) async {
    try {
      await GoProApiService.setPhotoResolution(password, option);
      await onSettingChanged();
    } catch (error, stackTrace) {
      AppLogger.error('Error setting photo resolution', error, stackTrace);
    }
  }

  Future<void> _setBurstRate(BurstRate option) async {
    try {
      await GoProApiService.setBurstRate(password, option);
      await onSettingChanged();
    } catch (error, stackTrace) {
      AppLogger.error('Error setting burst rate', error, stackTrace);
    }
  }

  Future<void> _setTimelapseInterval(TimelapseInterval option) async {
    try {
      await GoProApiService.setTimelapseInterval(password, option);
      await onSettingChanged();
    } catch (error, stackTrace) {
      AppLogger.error('Error setting timelapse interval', error, stackTrace);
    }
  }

  Widget _buildResolutionSelector(BuildContext context) {
    return PhotoResolutionSelectorWidget(
      cameraState: cameraState,
      onResolutionChanged: _setPhotoResolution,
    );
  }

  Widget _buildBurstRateSelector(BuildContext context) {
    final BurstRate currentBurstRate = cameraState.status.burstRate;
    final BurstRate? selectedValue = BurstRate.all.contains(currentBurstRate)
        ? currentBurstRate
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Burst Rate'),
        DropdownButton<BurstRate>(
          isExpanded: true,
          value: selectedValue,
          onChanged: cameraState.isCameraOn
              ? (newValue) {
                  if (newValue != null) {
                    _setBurstRate(newValue);
                  }
                }
              : null,
          items: BurstRate.all
              .map(
                (rate) => DropdownMenuItem(
                  value: rate,
                  child: Text(rate.getLocalizedName(context)),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildTimelapseIntervalSelector(BuildContext context) {
    final TimelapseInterval currentInterval =
        cameraState.status.timelapseInterval;
    final TimelapseInterval? selectedValue =
        TimelapseInterval.all.contains(currentInterval)
        ? currentInterval
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Timelapse Interval'),
        DropdownButton<TimelapseInterval>(
          isExpanded: true,
          value: selectedValue,
          onChanged: cameraState.isCameraOn
              ? (newValue) {
                  if (newValue != null) {
                    _setTimelapseInterval(newValue);
                  }
                }
              : null,
          items: TimelapseInterval.all
              .map(
                (interval) => DropdownMenuItem(
                  value: interval,
                  child: Text(interval.getLocalizedName(context)),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTimelapse =
        cameraState.status.cameraMode == CameraMode.timelapseMode;
    final isBurst = cameraState.status.cameraMode == CameraMode.burstMode;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildResolutionSelector(context),
            if (isTimelapse || isBurst) const SizedBox(height: 12),
            if (isTimelapse) _buildTimelapseIntervalSelector(context),
            if (isBurst) _buildBurstRateSelector(context),
          ],
        ),
      ),
    );
  }
}

class PhotoResolutionSelectorWidget extends StatefulWidget {
  final CameraState cameraState;
  final Future<void> Function(PhotoResolution) onResolutionChanged;

  const PhotoResolutionSelectorWidget({
    super.key,
    required this.cameraState,
    required this.onResolutionChanged,
  });

  @override
  State<PhotoResolutionSelectorWidget> createState() =>
      _PhotoResolutionSelectorWidgetState();
}

class _PhotoResolutionSelectorWidgetState
    extends State<PhotoResolutionSelectorWidget> {
  late PhotoZoom _selectedZoom;
  late PhotoResolution _selectedResolution;

  @override
  void initState() {
    super.initState();
    _selectedResolution = widget.cameraState.status.photoResolution;
    _selectedZoom = _selectedResolution.zoom;
  }

  @override
  void didUpdateWidget(PhotoResolutionSelectorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newResolution = widget.cameraState.status.photoResolution;
    if (newResolution != oldWidget.cameraState.status.photoResolution) {
      setState(() {
        _selectedResolution = newResolution;
        _selectedZoom = newResolution.zoom;
      });
    }
  }

  void _onZoomChanged(PhotoZoom newZoom) {
    final newResolution = PhotoResolution.forZoom(newZoom).first;
    setState(() {
      _selectedZoom = newZoom;
      _selectedResolution = newResolution;
    });
    AppLogger.info(
      'Changing photo zoom to ${newZoom.name}, auto-selecting resolution ${newResolution.value}',
    );
    widget.onResolutionChanged(newResolution);
  }

  void _onResolutionChanged(PhotoResolution newResolution) {
    setState(() => _selectedResolution = newResolution);
    AppLogger.info('Changing photo resolution to ${newResolution.value}');
    widget.onResolutionChanged(newResolution);
  }

  @override
  Widget build(BuildContext context) {
    final resolutions = PhotoResolution.forZoom(_selectedZoom);
    final validResolution = resolutions.contains(_selectedResolution)
        ? _selectedResolution
        : null;

    final otherZoom = _selectedZoom == PhotoZoom.wide
        ? PhotoZoom.medium
        : PhotoZoom.wide;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Photo Resolution'),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Tooltip(
              message: _selectedZoom.getLocalizedName(context),
              child: IconButton.filledTonal(
                icon: Icon(_selectedZoom.icon),
                onPressed: () => _onZoomChanged(otherZoom),
              ),
            ),
            const SizedBox(width: 4),
            DropdownButton<PhotoResolution>(
              value: validResolution,
              onChanged: (newValue) {
                if (newValue != null) _onResolutionChanged(newValue);
              },
              items: resolutions
                  .map(
                    (resolution) => DropdownMenuItem(
                      value: resolution,
                      child: Tooltip(
                        message: resolution.getLocalizedName(context),
                        child: Center(child: resolution.icon),
                      ),
                    ),
                  )
                  .toList(),
              selectedItemBuilder: (context) => resolutions
                  .map(
                    (resolution) => Center(
                      child: Tooltip(
                        message: resolution.getLocalizedName(context),
                        child: resolution.icon,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ],
    );
  }
}
