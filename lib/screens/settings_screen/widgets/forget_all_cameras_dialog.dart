import 'package:flutter/material.dart';
import 'package:heroctrl/l10n/app_localizations.dart';
import 'package:heroctrl/services/gopro_prefs.dart';
import 'package:heroctrl/widgets/red_button.dart';

class ForgetAllCamerasDialog extends StatelessWidget {
  const ForgetAllCamerasDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final navigatorState = Navigator.of(context);

    return AlertDialog(
      title: Text(localizations.forgetAllCameras),
      content: Text(localizations.forgetAllCamerasConfirm),
      actions: [
        TextButton(
          onPressed: () {
            navigatorState.pop();
          },
          child: Text(localizations.cancel),
        ),
        RedButton(
          onPressed: () async {
            await GoProPrefs.clearAll();
            navigatorState.pop();
          },
          child: Text(localizations.forget),
        ),
      ],
    );
  }
}
