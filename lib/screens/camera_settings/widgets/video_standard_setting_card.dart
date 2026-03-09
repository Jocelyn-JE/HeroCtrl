import 'package:flutter/material.dart';
import 'package:heroctrl/constants/gopro_system_enums.dart';
import 'package:heroctrl/l10n/app_localizations.dart';
import 'package:heroctrl/services/gopro_api_service.dart';
import 'package:heroctrl/utils/logger.dart';
import 'package:heroctrl/utils/snackbar.dart';

class VideoStandardSettingCard extends StatefulWidget {
  final String password;

  const VideoStandardSettingCard({super.key, required this.password});

  @override
  State<VideoStandardSettingCard> createState() =>
      _VideoStandardSettingCardState();
}

class _VideoStandardSettingCardState extends State<VideoStandardSettingCard> {
  VideoStandard? _currentStandard;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchVideoStandardSetting();
  }

  Future<void> _fetchVideoStandardSetting() async {
    try {
      final standard = await GoProApiService.getVideoMode(widget.password);
      if (mounted) {
        setState(() {
          _currentStandard = standard;
          _isLoading = false;
        });
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching video standard setting', e, stackTrace);
      if (mounted) {
        setState(() => _isLoading = false);
        showSnackBarError(context, 'Error fetching video standard setting: $e');
      }
    }
  }

  Future<void> _setVideoStandard(VideoStandard value) async {
    final previous = _currentStandard;
    setState(() => _currentStandard = value);
    try {
      await GoProApiService.setVideoMode(widget.password, value);
    } catch (e, stackTrace) {
      AppLogger.error('Error setting video standard', e, stackTrace);
      if (mounted) {
        setState(() => _currentStandard = previous);
        showSnackBarError(context, 'Error setting video standard: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.videoStandardSettingTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              l10n.videoStandardSettingSubtitle,
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
                child: SegmentedButton<VideoStandard>(
                  segments: [
                    ButtonSegment(
                      value: VideoStandard.ntsc,
                      label: Text(l10n.videoStandardNtsc),
                      icon: const Icon(Icons.videocam),
                    ),
                    ButtonSegment(
                      value: VideoStandard.pal,
                      label: Text(l10n.videoStandardPal),
                      icon: const Icon(Icons.videocam_outlined),
                    ),
                  ],
                  selected: {_currentStandard ?? VideoStandard.pal},
                  onSelectionChanged: (selected) =>
                      _setVideoStandard(selected.first),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
