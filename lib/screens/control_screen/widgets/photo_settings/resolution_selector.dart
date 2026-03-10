import 'package:flutter/material.dart';
import 'package:heroctrl/constants/gopro_photo_enums.dart';
import 'package:heroctrl/models/camera_state.dart';
import 'package:heroctrl/services/gopro_api_service.dart';
import 'package:heroctrl/utils/logger.dart';

class ResolutionSelector extends StatefulWidget {
  final CameraState cameraState;
  final String password;
  final Future<void> Function() onResolutionChanged;
  final EdgeInsetsGeometry padding;

  const ResolutionSelector({
    super.key,
    required this.cameraState,
    required this.password,
    required this.onResolutionChanged,
    this.padding = const EdgeInsets.all(8.0),
  });

  @override
  State<ResolutionSelector> createState() => _ResolutionSelectorState();
}

class _ResolutionSelectorState extends State<ResolutionSelector> {
  late PhotoZoom _selectedZoom;
  late PhotoResolution _selectedResolution;

  @override
  void initState() {
    super.initState();
    _selectedResolution = widget.cameraState.status.photoResolution;
    _selectedZoom = _selectedResolution.zoom;
  }

  @override
  void didUpdateWidget(ResolutionSelector oldWidget) {
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
    GoProApiService.setPhotoResolution(widget.password, newResolution).then((
      _,
    ) {
      widget.onResolutionChanged();
    });
  }

  void _onResolutionChanged(PhotoResolution newResolution) {
    setState(() => _selectedResolution = newResolution);
    AppLogger.info('Changing photo resolution to ${newResolution.value}');
    GoProApiService.setPhotoResolution(widget.password, newResolution).then((
      _,
    ) {
      widget.onResolutionChanged();
    });
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

    return Padding(
      padding: widget.padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
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
                      message: resolution.getLocalizedMpName(context),
                      child: Center(child: resolution.icon),
                    ),
                  ),
                )
                .toList(),
            selectedItemBuilder: (context) => resolutions
                .map(
                  (resolution) => Center(
                    child: Tooltip(
                      message: resolution.getLocalizedMpName(context),
                      child: resolution.icon,
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
