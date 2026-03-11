import 'package:flutter/material.dart';
import 'package:heroctrl/l10n/app_localizations.dart';
import 'package:heroctrl/services/app_prefs.dart';

class DisconnectSwitchCard extends StatefulWidget {
  const DisconnectSwitchCard({super.key});

  @override
  State<DisconnectSwitchCard> createState() => _DisconnectSwitchCardState();
}

class _DisconnectSwitchCardState extends State<DisconnectSwitchCard> {
  bool _value = true;

  @override
  void initState() {
    super.initState();
    _loadPreference();
  }

  Future<void> _loadPreference() async {
    final value = await AppPrefs.getSwitchOffCameraOnDisconnect();
    if (mounted) setState(() => _value = value);
  }

  Future<void> _updateValue(bool value) async {
    await AppPrefs.setSwitchOffCameraOnDisconnect(value);
    if (mounted) setState(() => _value = value);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: SwitchListTile(
        title: Text(l10n.switchOffCameraOnDisconnect),
        subtitle: Text(l10n.switchOffCameraOnDisconnectSubtitle),
        value: _value,
        onChanged: _updateValue,
      ),
    );
  }
}
