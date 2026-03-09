import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heroctrl/screens/control_screen/widgets/battery_indicator.dart';

void main() {
  Widget createTestableWidget(Widget child) {
    return MaterialApp(
      home: Scaffold(appBar: AppBar(actions: [child])),
    );
  }

  group('BatteryIndicator', () {
    testWidgets('displays battery percentage', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const BatteryIndicator(
            batteryPercent: 75,
            estimatedMinutesRemaining: 60,
          ),
        ),
      );

      expect(find.text('75%'), findsOneWidget);
    });

    testWidgets('displays estimated time when available', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const BatteryIndicator(
            batteryPercent: 50,
            estimatedMinutesRemaining: 90,
          ),
        ),
      );

      // Should show "~1h30m" for 90 minutes
      expect(find.text('~1h30m'), findsOneWidget);
    });

    testWidgets('shows only minutes when less than 60 minutes', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const BatteryIndicator(
            batteryPercent: 25,
            estimatedMinutesRemaining: 45,
          ),
        ),
      );

      expect(find.text('~45m'), findsOneWidget);
    });

    testWidgets('shows battery icon appropriate for level', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const BatteryIndicator(
            batteryPercent: 80,
            estimatedMinutesRemaining: null,
          ),
        ),
      );

      // Should show some battery bar icon (not testing exact icon)
      expect(find.byType(Icon), findsOneWidget);
    });

    testWidgets('handles high battery level', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const BatteryIndicator(
            batteryPercent: 95,
            estimatedMinutesRemaining: 180,
          ),
        ),
      );

      expect(find.text('95%'), findsOneWidget);
      expect(find.text('~3h'), findsOneWidget);
    });

    testWidgets('handles low battery level', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const BatteryIndicator(
            batteryPercent: 5,
            estimatedMinutesRemaining: 5,
          ),
        ),
      );

      expect(find.text('5%'), findsOneWidget);
      expect(find.text('~5m'), findsOneWidget);
    });

    testWidgets('shows critical alert icon when battery is below 5%', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(
          const BatteryIndicator(
            batteryPercent: 4,
            estimatedMinutesRemaining: 2,
          ),
        ),
      );

      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.icon, Icons.battery_alert);
      expect(icon.color, Colors.red);
      expect(find.text('4%'), findsOneWidget);
      expect(find.text('~2m'), findsOneWidget);
    });

    testWidgets('handles null estimated time', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const BatteryIndicator(
            batteryPercent: 50,
            estimatedMinutesRemaining: null,
          ),
        ),
      );

      expect(find.text('50%'), findsOneWidget);
      // Should not crash and should still show percentage
    });

    testWidgets('renders non-low battery color with custom theme', (
      tester,
    ) async {
      const fallbackColor = Colors.deepOrange;

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
            ).copyWith(onSurface: fallbackColor),
          ),
          home: Scaffold(
            body: IconTheme(
              data: const IconThemeData(color: null),
              child: const BatteryIndicator(
                batteryPercent: 50,
                estimatedMinutesRemaining: null,
              ),
            ),
          ),
        ),
      );

      final icon = tester.widget<Icon>(find.byType(Icon));
      final percentText = tester.widget<Text>(find.text('50%'));

      expect(icon.color, isNot(Colors.red));
      expect(percentText.style?.color, isNot(Colors.red));
    });

    testWidgets('handles zero estimated time', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const BatteryIndicator(
            batteryPercent: 1,
            estimatedMinutesRemaining: 0,
          ),
        ),
      );

      expect(find.text('1%'), findsOneWidget);
      expect(find.text('~0m'), findsOneWidget);
    });

    testWidgets('formats hours correctly', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const BatteryIndicator(
            batteryPercent: 100,
            estimatedMinutesRemaining: 125, // 2h 5m
          ),
        ),
      );

      expect(find.text('~2h5m'), findsOneWidget);
    });
  });
}
