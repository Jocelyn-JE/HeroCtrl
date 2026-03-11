import 'package:flutter/material.dart';
import 'package:heroctrl/l10n/app_localizations.dart';
import 'package:heroctrl/models/camera_state.dart';
import 'package:heroctrl/services/app_prefs.dart';
import 'package:heroctrl/utils/camera_state_conditions.dart';

class MediaCountDisplay extends StatefulWidget {
  final CameraState? cameraState;

  const MediaCountDisplay({super.key, required this.cameraState});

  @override
  State<MediaCountDisplay> createState() => _MediaCountDisplayState();
}

class _MediaCountDisplayState extends State<MediaCountDisplay> {
  bool _showMediaCount = true;

  @override
  void initState() {
    super.initState();
    _loadPreference();
  }

  @override
  void didUpdateWidget(MediaCountDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.cameraState != widget.cameraState) {
      _loadPreference();
    }
  }

  Future<void> _loadPreference() async {
    final value = await AppPrefs.getShowMediaCount();
    if (mounted && value != _showMediaCount) {
      setState(() => _showMediaCount = value);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_showMediaCount) return const SizedBox.shrink();

    final cameraState = widget.cameraState;
    if (cameraState == null) return const SizedBox.shrink();
    if (CameraStateConditions.isRecording(cameraState)) {
      return const SizedBox.shrink();
    }
    if (CameraStateConditions.isInSettingsMode(cameraState)) {
      return const SizedBox.shrink();
    }

    final l10n = AppLocalizations.of(context)!;
    final status = cameraState.status;
    final String label;
    final IconData icon;

    if (CameraStateConditions.isInVideoMode(cameraState)) {
      label = l10n.mediaCountVideos(status.videosTaken);
      icon = Icons.videocam_outlined;
    } else {
      label = l10n.mediaCountPhotos(status.photosTaken);
      icon = Icons.camera_alt_outlined;
    }

    final color = Theme.of(context).colorScheme.onSurfaceVariant;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
