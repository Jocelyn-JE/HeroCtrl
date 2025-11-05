import 'package:flutter/material.dart';
import 'package:heroctrl/core/utils/logger.dart';

import 'package:heroctrl/screens/home_screen.dart';
import 'package:heroctrl/screens/settings_screen.dart';
import 'package:heroctrl/screens/camera_search_screen.dart';

void main() {
  AppLogger.init(); // Initialize logger
  AppLogger.info('App started');
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
      routes: {
        '/settings': (context) => SettingsScreen(),
        '/camera_search': (context) => CameraSearchScreen(),
      },
    );
  }
}
