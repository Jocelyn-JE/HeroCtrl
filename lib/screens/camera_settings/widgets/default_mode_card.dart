import 'package:flutter/material.dart';
import 'package:heroctrl/constants/gopro_system_enums.dart';
import 'package:heroctrl/l10n/app_localizations.dart';
import 'package:heroctrl/services/gopro_api_service.dart';
import 'package:heroctrl/utils/logger.dart';
import 'package:heroctrl/utils/snackbar.dart';

class DefaultModeCard extends StatefulWidget {
  final String password;

  const DefaultModeCard({super.key, required this.password});

  @override
  State<DefaultModeCard> createState() => _DefaultModeCardState();
}

class _DefaultModeCardState extends State<DefaultModeCard> {
  DefaultCameraMode? _currentDefaultMode;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDefaultModeSetting();
  }

  Future<void> _fetchDefaultModeSetting() async {
    try {
      final defaultMode = await GoProApiService.getDefaultMode(widget.password);
      if (mounted) {
        setState(() {
          _currentDefaultMode = defaultMode;
          _isLoading = false;
        });
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching default mode setting', e, stackTrace);
      if (mounted) {
        setState(() => _isLoading = false);
        showSnackBarError(context, 'Error fetching default mode setting: $e');
      }
    }
  }

  Future<void> _setDefaultMode(DefaultCameraMode value) async {
    final previous = _currentDefaultMode;
    setState(() => _currentDefaultMode = value);
    try {
      await GoProApiService.setDefaultMode(widget.password, value);
    } catch (e, stackTrace) {
      AppLogger.error('Error setting default mode', e, stackTrace);
      if (mounted) {
        setState(() => _currentDefaultMode = previous);
        showSnackBarError(context, 'Error setting default mode: $e');
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
              localizations.defaultModeSetting,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              localizations.defaultModeSettingSubtitle,
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
                child: DropdownButton<DefaultCameraMode>(
                  isExpanded: true,
                  items: [
                    DropdownMenuItem(
                      value: DefaultCameraMode.videoMode,
                      child: Row(
                        children: [
                          const Icon(Icons.videocam),
                          const SizedBox(width: 12),
                          Text(localizations.defaultModeVideo),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: DefaultCameraMode.photoMode,
                      child: Row(
                        children: [
                          const Icon(Icons.photo_camera),
                          const SizedBox(width: 12),
                          Text(localizations.defaultModePhoto),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: DefaultCameraMode.burstMode,
                      child: Row(
                        children: [
                          const Icon(Icons.burst_mode),
                          const SizedBox(width: 12),
                          Text(localizations.defaultModeBurst),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: DefaultCameraMode.timeLapseMode,
                      child: Row(
                        children: [
                          const Icon(Icons.timelapse),
                          const SizedBox(width: 12),
                          Text(localizations.defaultModeTimeLapse),
                        ],
                      ),
                    ),
                  ],
                  value: _currentDefaultMode,
                  onChanged: (value) => _setDefaultMode(value!),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
