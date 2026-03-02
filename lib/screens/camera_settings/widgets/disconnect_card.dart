import 'package:flutter/material.dart';
import 'package:heroctrl/l10n/app_localizations.dart';
import 'package:heroctrl/services/app_prefs.dart';
import 'package:heroctrl/services/gopro_api_service.dart';
import 'package:heroctrl/utils/app_routes.dart';
import 'package:heroctrl/utils/logger.dart';
import 'package:heroctrl/utils/snackbar.dart';

class DisconnectCard extends StatefulWidget {
  final String password;

  const DisconnectCard({super.key, required this.password});

  @override
  State<DisconnectCard> createState() => _DisconnectCardState();
}

class _DisconnectCardState extends State<DisconnectCard> {
  bool? _autoShutoffEnabled;
  bool _isBusy = false;

  @override
  void initState() {
    super.initState();
    _loadPref();
  }

  Future<void> _loadPref() async {
    final enabled = await AppPrefs.getSwitchOffCameraOnDisconnect();
    if (mounted) setState(() => _autoShutoffEnabled = enabled);
  }

  Future<void> _confirmAndDisconnect() async {
    final localizations = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.power_settings_new),
        title: Text(localizations.disconnectConfirmTitle),
        content: Text(localizations.disconnectConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(localizations.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(localizations.disconnectConfirmButton),
          ),
        ],
      ),
    );
    if (confirmed == true) await _disconnectAndShutOff();
  }

  Future<void> _disconnectAndShutOff() async {
    setState(() => _isBusy = true);
    try {
      await GoProApiService.turnOffCamera(widget.password);
    } catch (e, stackTrace) {
      AppLogger.error('Error turning off camera', e, stackTrace);
      if (mounted) {
        showSnackBarError(context, 'Error turning off camera: $e');
        setState(() => _isBusy = false);
        return;
      }
    }
    if (mounted) {
      Navigator.of(context).popUntil(ModalRoute.withName(AppRoutes.home));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Only show this card when auto-shutoff on disconnect is disabled,
    // since enabling that preference already handles shutoff on disconnect.
    if (_autoShutoffEnabled == null || _autoShutoffEnabled == true) {
      AppLogger.info(
        'Auto-shutoff on disconnect is enabled, hiding DisconnectCard',
      );
      return const SizedBox.shrink();
    }

    final localizations = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizations.disconnectTitle,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    localizations.disconnectSubtitle,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            SizedBox.square(
              dimension: 48,
              child: ElevatedButton(
                onPressed: _isBusy ? null : _confirmAndDisconnect,
                style: ElevatedButton.styleFrom(padding: EdgeInsets.zero),
                child: _isBusy
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.power_settings_new),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
