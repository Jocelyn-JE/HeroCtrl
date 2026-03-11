import 'package:flutter/material.dart';
import 'package:heroctrl/l10n/app_localizations.dart';
import 'package:heroctrl/services/gopro_api_service.dart';
import 'package:heroctrl/utils/logger.dart';
import 'package:heroctrl/utils/snackbar.dart';

class FormatSdCard extends StatefulWidget {
  final String password;

  const FormatSdCard({super.key, required this.password});

  @override
  State<FormatSdCard> createState() => _FormatSdCardState();
}

class _FormatSdCardState extends State<FormatSdCard> {
  bool _isBusy = false;

  Future<void> _confirmAndFormat() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.sd_storage),
        title: Text(l10n.formatSdCardConfirmTitle),
        content: Text(l10n.formatSdCardConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.formatSdCardConfirmButton),
          ),
        ],
      ),
    );
    if (confirmed == true) await _formatSdCard();
  }

  Future<void> _formatSdCard() async {
    setState(() => _isBusy = true);
    try {
      await GoProApiService.formatSDCard(widget.password);
      if (mounted) {
        showSnackBarSuccess(context, 'SD card formatted successfully');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error formatting SD card', e, stackTrace);
      if (mounted) {
        showSnackBarError(context, 'Error formatting SD card: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isBusy = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
                    l10n.formatSdCardTitle,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.formatSdCardSubtitle,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            SizedBox.square(
              dimension: 48,
              child: ElevatedButton(
                onPressed: _isBusy ? null : _confirmAndFormat,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  iconColor: Colors.red,
                ),
                child: _isBusy
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.sd_storage, size: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
