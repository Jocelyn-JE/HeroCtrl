import 'package:flutter/material.dart';
import 'package:heroctrl/constants/gopro_system_enums.dart';
import 'package:heroctrl/l10n/app_localizations.dart';
import 'package:heroctrl/services/gopro_api_service.dart';
import 'package:heroctrl/utils/logger.dart';
import 'package:heroctrl/utils/snackbar.dart';

class VolumeSettingCard extends StatefulWidget {
  final String password;

  const VolumeSettingCard({super.key, required this.password});

  @override
  State<VolumeSettingCard> createState() => _VolumeSettingCardState();
}

class _VolumeSettingCardState extends State<VolumeSettingCard> {
  Volume? _currentVolume;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchVolumeSetting();
  }

  Future<void> _fetchVolumeSetting() async {
    try {
      final volume = await GoProApiService.getVolume(widget.password);
      if (mounted) {
        setState(() {
          _currentVolume = volume;
          _isLoading = false;
        });
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching volume setting', e, stackTrace);
      if (mounted) {
        setState(() => _isLoading = false);
        showSnackBarError(context, 'Error fetching volume setting: $e');
      }
    }
  }

  Future<void> _setVolume(Volume value) async {
    final previous = _currentVolume;
    setState(() => _currentVolume = value);
    try {
      await GoProApiService.setVolume(widget.password, value);
    } catch (e, stackTrace) {
      AppLogger.error('Error setting volume', e, stackTrace);
      if (mounted) {
        setState(() => _currentVolume = previous);
        showSnackBarError(context, 'Error setting volume: $e');
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
              localizations.volumeSetting,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              localizations.volumeSettingSubtitle,
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
                child: SegmentedButton<Volume>(
                  segments: [
                    ButtonSegment(
                      value: Volume.mute,
                      label: Text(localizations.volumeOff),
                      icon: const Icon(Icons.volume_off),
                    ),
                    ButtonSegment(
                      value: Volume.percent70,
                      label: Text(localizations.volumeLow),
                      icon: const Icon(Icons.volume_down),
                    ),
                    ButtonSegment(
                      value: Volume.percent100,
                      label: Text(localizations.volumeHigh),
                      icon: const Icon(Icons.volume_up),
                    ),
                  ],
                  selected: {_currentVolume ?? Volume.percent100},
                  onSelectionChanged: (selected) => _setVolume(selected.first),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
