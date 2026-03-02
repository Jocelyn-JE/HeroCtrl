import 'package:flutter/material.dart';
import 'package:heroctrl/constants/gopro_endpoints.dart';
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
  int? _currentLed;
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
        showSnackBar(
          context,
          'Error fetching LED setting: $e',
          color: Colors.red,
        );
      }
    }
  }

  Future<void> _setLed(int value) async {
    final previous = _currentLed;
    setState(() => _currentLed = value);
    try {
      await GoProApiService.setLeds(widget.password, value);
    } catch (e, stackTrace) {
      AppLogger.error('Error setting LEDs', e, stackTrace);
      if (mounted) {
        setState(() => _currentLed = previous);
        showSnackBar(context, 'Error setting LEDs: $e', color: Colors.red);
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
              localizations.ledSetting,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              localizations.ledSettingSubtitle,
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
                child: SegmentedButton<int>(
                  segments: [
                    ButtonSegment(
                      value: LED.off,
                      label: Text(localizations.ledOff),
                      icon: const Icon(Icons.flash_off),
                    ),
                    ButtonSegment(
                      value: LED.twoLeds,
                      label: Text(localizations.ledTwo),
                      icon: const Icon(Icons.flash_on),
                    ),
                    ButtonSegment(
                      value: LED.fourLeds,
                      label: Text(localizations.ledFour),
                      icon: const Icon(Icons.flashlight_on),
                    ),
                  ],
                  selected: {_currentLed ?? LED.fourLeds},
                  onSelectionChanged: (selected) => _setLed(selected.first),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
