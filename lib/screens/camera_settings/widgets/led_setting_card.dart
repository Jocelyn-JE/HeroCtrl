import 'package:flutter/material.dart';
import 'package:heroctrl/constants/gopro_system_enums.dart';
import 'package:heroctrl/l10n/app_localizations.dart';
import 'package:heroctrl/services/gopro_api_service.dart';
import 'package:heroctrl/utils/logger.dart';
import 'package:heroctrl/utils/snackbar.dart';

class LedSettingCard extends StatefulWidget {
  final String password;

  const LedSettingCard({super.key, required this.password});

  @override
  State<LedSettingCard> createState() => _LedSettingCardState();
}

class _LedSettingCardState extends State<LedSettingCard> {
  Led? _currentLed;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLedSetting();
  }

  Future<void> _fetchLedSetting() async {
    try {
      final led = await GoProApiService.getLeds(widget.password);
      if (mounted) {
        setState(() {
          _currentLed = led;
          _isLoading = false;
        });
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching LED setting', e, stackTrace);
      if (mounted) {
        setState(() => _isLoading = false);
        showSnackBarError(context, 'Error fetching LED setting: $e');
      }
    }
  }

  Future<void> _setLed(Led value) async {
    final previous = _currentLed;
    setState(() => _currentLed = value);
    try {
      await GoProApiService.setLeds(widget.password, value);
    } catch (e, stackTrace) {
      AppLogger.error('Error setting LEDs', e, stackTrace);
      if (mounted) {
        setState(() => _currentLed = previous);
        showSnackBarError(context, 'Error setting LEDs: $e');
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
              l10n.ledSetting,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              l10n.ledSettingSubtitle,
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
                child: SegmentedButton<Led>(
                  segments: [
                    ButtonSegment(
                      value: Led.off,
                      label: Text(l10n.ledOff),
                      icon: const Icon(Icons.flash_off),
                    ),
                    ButtonSegment(
                      value: Led.twoLeds,
                      label: Text(l10n.ledTwo),
                      icon: const Icon(Icons.flash_on),
                    ),
                    ButtonSegment(
                      value: Led.fourLeds,
                      label: Text(l10n.ledFour),
                      icon: const Icon(Icons.flashlight_on),
                    ),
                  ],
                  selected: {_currentLed ?? Led.fourLeds},
                  onSelectionChanged: (selected) => _setLed(selected.first),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
