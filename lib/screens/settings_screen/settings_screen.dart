import 'package:flutter/material.dart';
import 'package:heroctrl/services/app_prefs.dart';
import 'package:heroctrl/widgets/red_button.dart';
import 'package:heroctrl/l10n/app_localizations.dart';
import 'widgets/forget_all_cameras_dialog.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _switchOffCameraOnDisconnect = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final value = await AppPrefs.getSwitchOffCameraOnDisconnect();
    setState(() {
      _switchOffCameraOnDisconnect = value;
    });
  }

  Future<void> _updateSwitchOffCameraOnDisconnect(bool value) async {
    await AppPrefs.setSwitchOffCameraOnDisconnect(value);
    setState(() {
      _switchOffCameraOnDisconnect = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final double bottomInset = MediaQuery.of(context).padding.bottom;
    return Scaffold(
      appBar: AppBar(title: Text(localizations.settings)),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(8, 0, 8, bottomInset),
          child: Column(
            children: [
              Card(
                child: SwitchListTile(
                  title: Text(localizations.switchOffCameraOnDisconnect),
                  subtitle: Text(
                    localizations.switchOffCameraOnDisconnectSubtitle,
                  ),
                  value: _switchOffCameraOnDisconnect,
                  onChanged: _updateSwitchOffCameraOnDisconnect,
                ),
              ),
              const Spacer(),
              Center(
                child: RedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => const ForgetAllCamerasDialog(),
                    );
                  },
                  child: Text(localizations.forgetAllCameras),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
