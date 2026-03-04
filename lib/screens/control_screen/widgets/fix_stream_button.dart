import 'package:flutter/material.dart';
import 'package:heroctrl/l10n/app_localizations.dart';
import 'package:heroctrl/services/gopro_api_service.dart';

class FixStreamButton extends StatelessWidget {
  final String camPassword;
  final Future<void> Function()? onFixStreamPressed;
  final VoidCallback? onPressedComplete;

  const FixStreamButton({
    super.key,
    required this.camPassword,
    this.onFixStreamPressed,
    this.onPressedComplete,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        try {
          if (onFixStreamPressed != null) {
            await onFixStreamPressed!();
          } else {
            await GoProApiService.startVideoPreview(camPassword);
          }
        } catch (e) {
          // Errors are expected if preview is already on
        } finally {
          onPressedComplete?.call();
        }
      },
      child: Text(AppLocalizations.of(context)!.fixStream),
    );
  }
}
