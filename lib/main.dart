import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:heroctrl/l10n/app_localizations.dart';
import 'package:heroctrl/utils/app_routes.dart';
import 'package:heroctrl/utils/logger.dart';
import 'package:media_kit/media_kit.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();

  // Suppress noisy internal logs from media_kit_video (VideoOutput.Resize etc.)
  final originalDebugPrint = debugPrint;
  debugPrint = (String? message, {int? wrapWidth}) {
    if (message != null &&
        (message.contains('VideoOutput.') || message.startsWith('{rect:'))) {
      return;
    }
    originalDebugPrint(message, wrapWidth: wrapWidth);
  };

  AppLogger.init(); // Initialize logger
  AppLogger.info('App started');

  runApp(const MainApp());
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
