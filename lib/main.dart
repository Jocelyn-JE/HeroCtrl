import 'package:flutter/material.dart';
import 'package:heroctrl/core/utils/logger.dart';
import 'package:heroctrl/services/gopro_api_service.dart';

import 'package:heroctrl/screens/home_screen.dart';
import 'package:heroctrl/screens/settings_screen.dart';

void main() {
  AppLogger.init(); // Initialize logger
  GoProApiService(); // Initialize singleton
  AppLogger.info('App started');
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
      routes: {'/settings': (context) => SettingsScreen()},
    );
  }
}
