import 'package:flutter/material.dart';
import 'package:heroctrl/constants/gopro_system_enums.dart';
import 'package:heroctrl/l10n/app_localizations.dart';
import 'package:heroctrl/services/gopro_api_service.dart';
import 'package:heroctrl/utils/logger.dart';
import 'package:heroctrl/utils/snackbar.dart';

class LocateCameraCard extends StatefulWidget {
  final String password;

  const LocateCameraCard({super.key, required this.password});

  @override
  State<LocateCameraCard> createState() => _LocateCameraCardState();
}

class _LocateCameraCardState extends State<LocateCameraCard> {
  bool _isLocating = false;

  Future<void> _startLocating() async {
    setState(() => _isLocating = true);
    Led previousLedMode = Led.fourLeds;
    try {
      await GoProApiService.setLocateCamera(widget.password, true);
      previousLedMode = await GoProApiService.getLeds(widget.password);
      await GoProApiService.setLeds(widget.password, Led.fourLeds);
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) =>
            _LocatingDialog(onStop: () => Navigator.of(context).pop()),
      );
    } catch (e, stackTrace) {
      AppLogger.error('Error starting locate camera', e, stackTrace);
      if (mounted) {
        showSnackBarError(context, 'Error locating camera: $e');
      }
    } finally {
      try {
        await GoProApiService.setLocateCamera(widget.password, false);
        await GoProApiService.setLeds(widget.password, previousLedMode);
      } catch (e, stackTrace) {
        AppLogger.error('Error stopping locate camera', e, stackTrace);
      }
      if (mounted) setState(() => _isLocating = false);
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
              l10n.locateCamera,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              l10n.locateCameraSubtitle,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLocating ? null : _startLocating,
                icon: _isLocating
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.my_location_outlined),
                label: Text(l10n.locateCameraButton),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LocatingDialog extends StatelessWidget {
  final VoidCallback onStop;

  const _LocatingDialog({required this.onStop});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      icon: const Icon(Icons.my_location_outlined, size: 40),
      title: Text(l10n.locateCameraDialogTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const LinearProgressIndicator(),
          const SizedBox(height: 16),
          Text(l10n.locateCameraDialogMessage),
        ],
      ),
      actions: [
        FilledButton(onPressed: onStop, child: Text(l10n.locateCameraStop)),
      ],
    );
  }
}
