import 'package:flutter/material.dart';
import 'package:heroctrl/models/gopro_registration.dart';
import 'package:heroctrl/services/gopro_prefs.dart';
import 'package:heroctrl/l10n/app_localizations.dart';
import 'widgets/camera_list_view.dart';
import 'widgets/camera_connection_handler.dart';

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
    _refreshCamerasList();
  }

  void _refreshCamerasList() {
    registeredGopros = GoProPrefs.getAll();
  }

  Future<void> _navigateToSettings() async {
    await Navigator.pushNamed(context, '/settings');
    setState(() {
      _refreshCamerasList();
    });
  }

  Future<void> _navigateToAddCamera() async {
    await Navigator.pushNamed(context, '/camera_search');
    setState(() {
      _refreshCamerasList();
    });
  }

  Future<void> _handleCameraTap(GoProRegistration camera) async {
    await CameraConnectionHandler.connect(context, camera);
  }

  void _handleCameraLongPress(GoProRegistration camera) {
    // TODO: camera info dialog with option to forget
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
            onPressed: _navigateToSettings,
          ),
        ],
      ),
      body: CameraListView(
        camerasFuture: registeredGopros,
        onCameraTap: _handleCameraTap,
        onCameraLongPress: _handleCameraLongPress,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddCamera,
        child: const Icon(Icons.add),
      ),
    );
  }
}
