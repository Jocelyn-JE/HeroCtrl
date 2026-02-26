import 'package:flutter/material.dart';
import 'package:heroctrl/screens/camera_search_screen/camera_search_screen.dart';
import 'package:heroctrl/screens/camera_settings/camera_settings_screen.dart';
import 'package:heroctrl/screens/control_screen/control_screen.dart';
import 'package:heroctrl/screens/home_screen/home_screen.dart';
import 'package:heroctrl/screens/settings_screen/settings_screen.dart';

class AppRoutes {
  // Route names
  static const String settings = '/settings';
  static const String register = '/camera_search';
  static const String home = '/home';
  static const String control = '/control';
  static const String cameraSettings = '/camera_settings';

  // Named routes
  static Map<String, WidgetBuilder> get routes => {
    settings: (context) => const SettingsScreen(),
    register: (context) => const CameraSearchScreen(),
    home: (context) => const HomeScreen(),
    control: (context) => const ControlScreen(),
    cameraSettings: (context) => const CameraSettingsScreen(),
  };
}
