import 'package:flutter/material.dart';
import 'package:heroctrl/screens/camera_search_screen.dart';
import 'package:heroctrl/screens/home_screen.dart';
import 'package:heroctrl/screens/settings_screen.dart';

class AppRoutes {
  // Route names
  static const String settings = '/settings';
  static const String register = '/camera_search';
  static const String home = '/home';

  // Named routes
  static Map<String, WidgetBuilder> get routes => {
    settings: (context) => const SettingsScreen(),
    register: (context) => const CameraSearchScreen(),
    home: (context) => const HomeScreen(),
  };
}
