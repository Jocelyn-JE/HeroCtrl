import 'package:flutter/material.dart';
import 'package:heroctrl/l10n/app_localizations.dart';

class EmptyCameraState extends StatelessWidget {
  const EmptyCameraState({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final double bottomInset = MediaQuery.of(context).padding.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(8, 0, 8, bottomInset),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(radius: 32, child: Icon(Icons.videocam_off, size: 32)),
            SizedBox(height: 16),
            Text(l10n.noCamerasFound, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
