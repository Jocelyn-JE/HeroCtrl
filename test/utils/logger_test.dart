import 'package:flutter_test/flutter_test.dart';
import 'package:heroctrl/utils/logger.dart';
import 'package:logging/logging.dart';

void main() {
  group('AppLogger', () {
    late List<LogRecord> logRecords;

    setUp(() {
      logRecords = [];
      // Clear any existing listeners and set up a test listener
      Logger.root.clearListeners();
      Logger.root.level = Level.ALL;
      Logger.root.onRecord.listen((record) {
        logRecords.add(record);
      });
    });

    tearDown(() {
      Logger.root.clearListeners();
      logRecords.clear();
    });

    test('init creates singleton and listener processes records', () {
      AppLogger.init();
      // Should not throw and should be callable multiple times.
      AppLogger.init();

      final exception = Exception('listener path');
      final stackTrace = StackTrace.current;
      AppLogger.error('listener test message', exception, stackTrace);

      expect(logRecords, isNotEmpty);
      expect(logRecords.last.level, Level.SEVERE);
      expect(logRecords.last.message, 'listener test message');
      expect(logRecords.last.error, exception);
      expect(logRecords.last.stackTrace, stackTrace);
    });

    test('init sets up logger with proper listener', () {
      // Clear listeners to test init behavior
      Logger.root.clearListeners();

      // Call init to trigger _create
      AppLogger.init();

      // Verify logger level is set
      expect(Logger.root.level, Level.ALL);

      // Logging should work without throwing
      Logger.root.info('Test message after init');
    });

    test('info logs at INFO level', () {
      AppLogger.info('Test info message');

      expect(logRecords.length, 1);
      expect(logRecords.first.level, Level.INFO);
      expect(logRecords.first.message, 'Test info message');
    });

    test('warning logs at WARNING level', () {
      AppLogger.warning('Test warning message');

      expect(logRecords.length, 1);
      expect(logRecords.first.level, Level.WARNING);
      expect(logRecords.first.message, 'Test warning message');
    });

    test('error logs at SEVERE level', () {
      AppLogger.error('Test error message');

      expect(logRecords.length, 1);
      expect(logRecords.first.level, Level.SEVERE);
      expect(logRecords.first.message, 'Test error message');
    });

    test('error logs with exception and stack trace', () {
      final exception = Exception('Test exception');
      final stackTrace = StackTrace.current;

      AppLogger.error('Test error with exception', exception, stackTrace);

      expect(logRecords.length, 1);
      expect(logRecords.first.level, Level.SEVERE);
      expect(logRecords.first.message, 'Test error with exception');
      expect(logRecords.first.error, exception);
      expect(logRecords.first.stackTrace, stackTrace);
    });

    test('logs multiple messages in sequence', () {
      AppLogger.info('First message');
      AppLogger.warning('Second message');
      AppLogger.error('Third message');

      expect(logRecords.length, 3);
      expect(logRecords[0].level, Level.INFO);
      expect(logRecords[1].level, Level.WARNING);
      expect(logRecords[2].level, Level.SEVERE);
    });

    test('logger respects log level', () {
      Logger.root.level = Level.WARNING;

      AppLogger.info('This should not be logged');
      AppLogger.warning('This should be logged');

      expect(logRecords.length, 1);
      expect(logRecords.first.level, Level.WARNING);
    });
  });
}
