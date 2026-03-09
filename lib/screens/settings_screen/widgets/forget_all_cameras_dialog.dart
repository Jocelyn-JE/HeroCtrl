import 'package:flutter/material.dart';
import 'package:heroctrl/l10n/app_localizations.dart';
import 'package:heroctrl/services/gopro_registry.dart';
import 'package:heroctrl/widgets/red_button.dart';

class ForgetAllCamerasDialog extends StatelessWidget {
  const ForgetAllCamerasDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final navigatorState = Navigator.of(context);

    return AlertDialog(
      title: Text(l10n.forgetAllCameras),
      content: Text(l10n.forgetAllCamerasConfirm),
      actions: [
        TextButton(
          onPressed: () {
            navigatorState.pop();
          },
          child: Text(l10n.cancel),
        ),
        RedButton(
          onPressed: () async {
            await GoProPrefs.clearAll();
            navigatorState.pop();
          },
          child: Text(l10n.forget),
        ),
      ],
    );
  }
}
