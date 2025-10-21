import 'package:flutter/material.dart';
import 'package:heroctrl/core/utils/logger.dart';
import 'package:heroctrl/screens/home_screen.dart';

void main() {
  AppLogger.init();
  AppLogger.info('App started');
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomeScreen());
  }
}
