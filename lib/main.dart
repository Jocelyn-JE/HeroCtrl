import 'package:flutter/material.dart';
import 'package:heroctrl/utils/app_routes.dart';
import 'package:heroctrl/utils/logger.dart';

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
      initialRoute: AppRoutes.register,
      routes: AppRoutes.routes,
    );
  }
}
