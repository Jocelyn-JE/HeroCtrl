import 'package:flutter/material.dart';
import 'package:heroctrl/services/gopro_prefs.dart';
import 'package:heroctrl/widgets/red_button.dart';
import 'package:heroctrl/l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final double bottomInset = MediaQuery.of(context).padding.bottom;
    return Scaffold(
      appBar: AppBar(title: Text(localizations.settings)),
      body: Padding(
        padding: EdgeInsets.fromLTRB(8, 0, 8, bottomInset),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
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
                    },
                  );
                },
                child: Text(localizations.forgetAllCameras),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
