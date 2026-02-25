import 'package:flutter/material.dart';
import 'package:heroctrl/models/gopro_registration.dart';
import 'package:heroctrl/services/gopro_prefs.dart';
import 'package:heroctrl/l10n/app_localizations.dart';
import 'widgets/camera_list_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _RegisterHomeScreenState();
}

class _RegisterHomeScreenState extends State<HomeScreen> {
  late Future<List<GoProRegistration>> registeredGopros;

  @override
  void initState() {
    super.initState();
    registeredGopros = GoProPrefs.getAll();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              await Navigator.pushNamed(context, '/settings');
              setState(() {
                registeredGopros = GoProPrefs.getAll();
              });
            },
          ),
        ],
      ),
      body: CameraListView(
        camerasFuture: registeredGopros,
        onCameraTap: (camera) {
          // switch to camera control screen
        },
        onCameraLongPress: (camera) {
          // camera info dialog with option to delete
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/camera_search');
          setState(() {
            registeredGopros = GoProPrefs.getAll();
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
