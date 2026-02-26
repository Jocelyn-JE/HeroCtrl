import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:heroctrl/l10n/app_localizations.dart';
import 'package:heroctrl/utils/app_routes.dart';
import 'package:heroctrl/utils/logger.dart';

void main() {
  AppLogger.init(); // Initialize logger
  AppLogger.info('App started');

  // Run app in a zone to catch better_player_plus live stream errors
  runZonedGuarded(() => runApp(const MainApp()), (error, stack) {
    // Known bug: live streams have invalid position values
    if (error is RangeError &&
        error.toString().contains('millisecondsSinceEpoch')) {
      return;
    }
    // ExoPlayer source errors are expected on a lossy WiFi stream and are
    // handled by LiveView's reconnect logic — no need to log as SEVERE here.
    if (error is PlatformException && error.code == 'VideoError') {
      return;
    }
    // 'Bad state: Future already completed' comes from BetterPlayer internals
    // when a reconnect is already in progress — safe to suppress.
    if (error.toString().contains('Bad state: Future already completed')) {
      return;
    }
    AppLogger.error('Unhandled error: $error', error, stack);
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
