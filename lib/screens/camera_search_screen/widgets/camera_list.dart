import 'package:flutter/material.dart';
import 'package:heroctrl/l10n/app_localizations.dart';
import 'package:wifi_scan/wifi_scan.dart';
import 'connection_dialog.dart';

class CameraList extends StatelessWidget {
  final List<WiFiAccessPoint> accessPoints;

  const CameraList({super.key, required this.accessPoints});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final double bottomInset = MediaQuery.of(context).padding.bottom;
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(8, 0, 8, bottomInset),
      itemCount: accessPoints.length,
      itemBuilder: (context, index) {
        final ssid = accessPoints[index].ssid;
        final bssid = accessPoints[index].bssid;
        return Card(
          child: ListTile(
            leading: CircleAvatar(child: Icon(Icons.videocam)),
            trailing: Icon(Icons.chevron_right),
            title: Text(ssid),
            subtitle: Text(localizations.bssidLabel(bssid)),
            onTap: () async {
              final navigator = Navigator.of(context);
              final connected = await showDialog<bool>(
                context: context,
                builder: (context) =>
                    ConnectionDialog(ssid: ssid, bssid: bssid),
              );
              if (connected != true) return;
              navigator.popUntil((route) => route.isFirst);
              scaffoldMessenger.clearSnackBars();
            },
          ),
        );
      },
    );
  }
}
