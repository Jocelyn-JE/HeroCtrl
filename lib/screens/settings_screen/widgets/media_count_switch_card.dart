import 'package:flutter/material.dart';
import 'package:heroctrl/l10n/app_localizations.dart';
import 'package:heroctrl/services/app_prefs.dart';

class MediaCountSwitchCard extends StatefulWidget {
  const MediaCountSwitchCard({super.key});

  @override
  State<MediaCountSwitchCard> createState() => _MediaCountSwitchCardState();
}

class _MediaCountSwitchCardState extends State<MediaCountSwitchCard> {
  bool _value = true;

  @override
  void initState() {
    super.initState();
    _loadPreference();
  }

  Future<void> _loadPreference() async {
    final value = await AppPrefs.getShowMediaCount();
    if (mounted) setState(() => _value = value);
  }

  Future<void> _updateValue(bool value) async {
    await AppPrefs.setShowMediaCount(value);
    if (mounted) setState(() => _value = value);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: SwitchListTile(
        title: Text(l10n.showMediaCount),
        subtitle: Text(l10n.showMediaCountSubtitle),
        value: _value,
        onChanged: _updateValue,
      ),
    );
  }
}
