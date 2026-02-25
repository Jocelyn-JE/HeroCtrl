import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:heroctrl/l10n/app_localizations.dart';
import 'package:heroctrl/utils/app_routes.dart';
import 'package:heroctrl/utils/logger.dart';

void main() {
  AppLogger.init(); // Initialize logger
  AppLogger.info('App started');

  // Run app in a zone to catch better_player_plus live stream position errors
  runZonedGuarded(() => runApp(const MainApp()), (error, stack) {
    // Suppress better_player_plus position query errors for live streams
    if (error is RangeError &&
        error.toString().contains('millisecondsSinceEpoch')) {
      // Known bug: live streams have invalid position values
      return;
    }
    // Log other errors
    AppLogger.error('Unhandled error', error, stack);
  });
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HeroCtrl',
      initialRoute: AppRoutes.home,
      routes: AppRoutes.routes,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowMaterialGrid: false,
      debugShowCheckedModeBanner: false,
    );
  }
}
