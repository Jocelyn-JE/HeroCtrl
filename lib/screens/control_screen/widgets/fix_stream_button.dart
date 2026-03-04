import 'package:flutter/material.dart';
import 'package:heroctrl/l10n/app_localizations.dart';
import 'package:heroctrl/services/gopro_api_service.dart';

class FixStreamButton extends StatelessWidget {
  final String camPassword;

  const FixStreamButton({super.key, required this.camPassword});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        try {
          await GoProApiService.startVideoPreview(camPassword);
        } catch (e) {
          // Errors are expected if preview is already on
        }
      },
      child: Text(AppLocalizations.of(context)!.fixStream),
    );
  }
}
