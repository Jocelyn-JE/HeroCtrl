import 'package:flutter/material.dart';
import 'package:heroctrl/widgets/red_button.dart';
import 'package:heroctrl/l10n/app_localizations.dart';
import 'widgets/forget_all_cameras_dialog.dart';

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
                    builder: (context) => const ForgetAllCamerasDialog(),
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
