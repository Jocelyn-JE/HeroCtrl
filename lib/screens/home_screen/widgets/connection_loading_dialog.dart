import 'package:flutter/material.dart';
import 'package:heroctrl/l10n/app_localizations.dart';

class ConnectionLoadingDialog extends StatelessWidget {
  final VoidCallback onCancel;

  const ConnectionLoadingDialog({super.key, required this.onCancel});

  static Future<void> show(
    BuildContext context, {
    required VoidCallback onCancel,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return ConnectionLoadingDialog(onCancel: onCancel);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return PopScope(
      canPop: false,
      child: AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(l10n.connectingToCamera, textAlign: TextAlign.center),
          ],
        ),
        actions: [TextButton(onPressed: onCancel, child: Text(l10n.cancel))],
      ),
    );
  }
}
