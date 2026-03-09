import 'package:flutter/material.dart';
import 'package:heroctrl/l10n/app_localizations.dart';
import 'package:heroctrl/services/gopro_api_service.dart';
import 'package:heroctrl/utils/logger.dart';
import 'package:heroctrl/utils/snackbar.dart';

class DeleteAllMediaCard extends StatefulWidget {
  final String password;

  const DeleteAllMediaCard({super.key, required this.password});

  @override
  State<DeleteAllMediaCard> createState() => _DeleteAllMediaCardState();
}

class _DeleteAllMediaCardState extends State<DeleteAllMediaCard> {
  bool _isBusy = false;

  Future<void> _confirmAndDelete() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.delete_forever),
        title: Text(l10n.deleteAllMediaConfirmTitle),
        content: Text(l10n.deleteAllMediaConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.deleteAllMediaConfirmButton),
          ),
        ],
      ),
    );
    if (confirmed == true) await _deleteAllMedia();
  }

  Future<void> _deleteAllMedia() async {
    setState(() => _isBusy = true);
    try {
      await GoProApiService.deleteAllMedia(widget.password);
      if (mounted) {
        showSnackBarSuccess(context, 'All media files deleted successfully');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error deleting all media', e, stackTrace);
      if (mounted) {
        showSnackBarError(context, 'Error deleting all media: $e');
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
                    l10n.deleteAllMediaTitle,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.deleteAllMediaSubtitle,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            SizedBox.square(
              dimension: 48,
              child: ElevatedButton(
                onPressed: _isBusy ? null : _confirmAndDelete,
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
                    : const Icon(Icons.delete_forever, size: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
