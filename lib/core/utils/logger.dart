import 'dart:developer' as developer;
import 'package:logging/logging.dart';

class AppLogger {
  static final _instance = AppLogger._create();

  /// Ensure the logger is initialized (call once at app startup).
  static void init() => _instance;
  static AppLogger _create() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((rec) {
      developer.log(
        '[${rec.level.name}] ${rec.time.toIso8601String()} ${rec.loggerName} - ${rec.message}',
        name: rec.loggerName,
        error: rec.error,
        stackTrace: rec.stackTrace,
        level: rec.level.value,
      );
    });
    return AppLogger._();
  }

  AppLogger._();

  static void info(String message) => Logger.root.info(message);
  static void warning(String message) => Logger.root.warning(message);
  static void error(String message, [Object? error, StackTrace? stackTrace]) =>
      Logger.root.severe(message, error, stackTrace);
}
