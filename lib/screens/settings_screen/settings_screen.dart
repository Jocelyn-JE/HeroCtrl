import 'package:flutter/material.dart';
import 'package:heroctrl/widgets/red_button.dart';
import 'package:heroctrl/l10n/app_localizations.dart';
import 'widgets/disconnect_switch_card.dart';
import 'widgets/forget_all_cameras_dialog.dart';
import 'widgets/media_count_switch_card.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final double bottomInset = MediaQuery.of(context).padding.bottom;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(8, 0, 8, bottomInset),
          child: Column(
            children: [
              const DisconnectSwitchCard(),
              const MediaCountSwitchCard(),
              const Spacer(),
              Center(
                child: RedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => const ForgetAllCamerasDialog(),
                    );
                  },
                  child: Text(l10n.forgetAllCameras),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
