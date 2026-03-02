import 'package:flutter/material.dart';
import 'package:heroctrl/constants/gopro_endpoints.dart';
import 'package:heroctrl/l10n/app_localizations.dart';
import 'package:heroctrl/services/gopro_api_service.dart';
import 'package:heroctrl/utils/logger.dart';
import 'package:heroctrl/utils/snackbar.dart';

class VideoModeSettingCard extends StatefulWidget {
  final String password;

  const VideoModeSettingCard({super.key, required this.password});

  @override
  State<VideoModeSettingCard> createState() => _VideoModeSettingCardState();
}

class _VideoModeSettingCardState extends State<VideoModeSettingCard> {
  VideoModes? _currentMode;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchVideoModeSetting();
  }

  Future<void> _fetchVideoModeSetting() async {
    try {
      final mode = await GoProApiService.getVideoMode(widget.password);
      if (mounted) {
        setState(() {
          _currentMode = mode;
          _isLoading = false;
        });
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching video mode setting', e, stackTrace);
      if (mounted) {
        setState(() => _isLoading = false);
        showSnackBarError(context, 'Error fetching video mode setting: $e');
      }
    }
  }

  Future<void> _setVideoMode(VideoModes value) async {
    final previous = _currentMode;
    setState(() => _currentMode = value);
    try {
      await GoProApiService.setVideoMode(widget.password, value);
    } catch (e, stackTrace) {
      AppLogger.error('Error setting video mode', e, stackTrace);
      if (mounted) {
        setState(() => _currentMode = previous);
        showSnackBarError(context, 'Error setting video mode: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.videoModeSettingTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              localizations.videoModeSettingSubtitle,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            if (_isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              )
            else
              SizedBox(
                width: double.infinity,
                child: SegmentedButton<VideoModes>(
                  segments: [
                    ButtonSegment(
                      value: VideoModes.ntsc,
                      label: Text(localizations.videoModeNtsc),
                      icon: const Icon(Icons.videocam),
                    ),
                    ButtonSegment(
                      value: VideoModes.pal,
                      label: Text(localizations.videoModePal),
                      icon: const Icon(Icons.videocam_outlined),
                    ),
                  ],
                  selected: {_currentMode ?? VideoModes.pal},
                  onSelectionChanged: (selected) =>
                      _setVideoMode(selected.first),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
