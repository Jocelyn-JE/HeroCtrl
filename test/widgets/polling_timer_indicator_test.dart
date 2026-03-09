import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heroctrl/widgets/polling_timer_indicator.dart';

void main() {
  Widget wrap(Widget child) {
    return MaterialApp(
      home: Scaffold(body: Center(child: child)),
    );
  }

  int secondsFromUi(WidgetTester tester) {
    final textWidget = tester.widget<Text>(find.byType(Text));
    return int.parse(textWidget.data!);
  }

  group('PollingTimerIndicator', () {
    testWidgets(
      'shows poll interval and zero progress when nextPollTime is null',
      (tester) async {
        addTearDown(() async {
          await tester.pumpWidget(const SizedBox.shrink());
          await tester.pump();
        });

        await tester.pumpWidget(
          wrap(
            const PollingTimerIndicator(
              nextPollTime: null,
              pollIntervalSeconds: 30,
            ),
          ),
        );

        final progress = tester.widget<CircularProgressIndicator>(
          find.byType(CircularProgressIndicator),
        );
        expect(progress.value, 0.0);
        expect(find.text('30'), findsOneWidget);
      },
    );

    testWidgets('timer mode periodic callback ticks while mounted', (
      tester,
    ) async {
      addTearDown(() async {
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump();
      });

      await tester.pumpWidget(
        wrap(
          const PollingTimerIndicator(
            nextPollTime: null,
            pollIntervalSeconds: 5,
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 250));
      expect(find.text('5'), findsOneWidget);
    });

    testWidgets(
      'clamps progress to one and seconds to zero for past poll time',
      (tester) async {
        addTearDown(() async {
          await tester.pumpWidget(const SizedBox.shrink());
          await tester.pump();
        });

        await tester.pumpWidget(
          wrap(
            PollingTimerIndicator(
              nextPollTime: DateTime.now().subtract(const Duration(seconds: 3)),
              pollIntervalSeconds: 20,
            ),
          ),
        );

        final progress = tester.widget<CircularProgressIndicator>(
          find.byType(CircularProgressIndicator),
        );
        expect(progress.value, 1.0);
        expect(find.text('0'), findsOneWidget);
      },
    );

    testWidgets('clamps progress to zero for far future poll time', (
      tester,
    ) async {
      addTearDown(() async {
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump();
      });

      await tester.pumpWidget(
        wrap(
          PollingTimerIndicator(
            nextPollTime: DateTime.now().add(const Duration(seconds: 120)),
            pollIntervalSeconds: 30,
          ),
        ),
      );

      final progress = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );
      expect(progress.value, 0.0);
      expect(secondsFromUi(tester), greaterThan(30));
    });

    testWidgets('uses listenable value in preference to nextPollTime', (
      tester,
    ) async {
      final notifier = ValueNotifier<DateTime?>(
        DateTime.now().add(const Duration(seconds: 3)),
      );

      await tester.pumpWidget(
        wrap(
          PollingTimerIndicator(
            nextPollTime: DateTime.now().add(const Duration(seconds: 25)),
            nextPollTimeListenable: notifier,
            pollIntervalSeconds: 30,
          ),
        ),
      );

      expect(secondsFromUi(tester), lessThanOrEqualTo(4));
    });

    testWidgets('rebinds listener when listenable instance changes', (
      tester,
    ) async {
      final notifierA = ValueNotifier<DateTime?>(
        DateTime.now().add(const Duration(seconds: 9)),
      );
      final notifierB = ValueNotifier<DateTime?>(
        DateTime.now().add(const Duration(seconds: 8)),
      );

      await tester.pumpWidget(
        wrap(
          PollingTimerIndicator(
            key: const ValueKey('polling-rebind'),
            nextPollTime: null,
            nextPollTimeListenable: notifierA,
            pollIntervalSeconds: 20,
          ),
        ),
      );

      await tester.pumpWidget(
        wrap(
          PollingTimerIndicator(
            key: const ValueKey('polling-rebind'),
            nextPollTime: null,
            nextPollTimeListenable: notifierB,
            pollIntervalSeconds: 20,
          ),
        ),
      );

      notifierB.value = DateTime.now().add(const Duration(seconds: 1));
      await tester.pump();
      expect(secondsFromUi(tester), lessThanOrEqualTo(2));

      // Updates from the old notifier should no longer drive this widget.
      notifierA.value = DateTime.now().add(const Duration(seconds: 19));
      await tester.pump();
      expect(secondsFromUi(tester), lessThanOrEqualTo(2));
    });

    testWidgets('updates when listenable value changes', (tester) async {
      final notifier = ValueNotifier<DateTime?>(
        DateTime.now().add(const Duration(seconds: 9)),
      );

      await tester.pumpWidget(
        wrap(
          PollingTimerIndicator(
            nextPollTime: null,
            nextPollTimeListenable: notifier,
            pollIntervalSeconds: 30,
          ),
        ),
      );

      notifier.value = DateTime.now().add(const Duration(seconds: 1));
      await tester.pump();

      expect(secondsFromUi(tester), lessThanOrEqualTo(2));
    });

    testWidgets('applies custom color and text style', (tester) async {
      const customStyle = TextStyle(fontSize: 18, color: Colors.purple);

      await tester.pumpWidget(
        wrap(
          PollingTimerIndicator(
            nextPollTime: DateTime.now().add(const Duration(seconds: 10)),
            color: Colors.teal,
            textStyle: customStyle,
          ),
        ),
      );

      final progress = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );
      final text = tester.widget<Text>(find.byType(Text));

      expect(progress.color, Colors.teal);
      expect(text.style?.fontSize, 18);
      expect(text.style?.color, Colors.purple);
    });

    testWidgets('switches from listenable to timer mode on widget update', (
      tester,
    ) async {
      final notifier = ValueNotifier<DateTime?>(
        DateTime.now().add(const Duration(seconds: 5)),
      );

      await tester.pumpWidget(
        wrap(
          PollingTimerIndicator(
            key: const ValueKey('polling'),
            nextPollTime: null,
            nextPollTimeListenable: notifier,
            pollIntervalSeconds: 12,
          ),
        ),
      );

      await tester.pumpWidget(
        wrap(
          const PollingTimerIndicator(
            key: ValueKey('polling'),
            nextPollTime: null,
            nextPollTimeListenable: null,
            pollIntervalSeconds: 12,
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 250));
      expect(find.text('12'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
    });

    testWidgets(
      'switches from timer mode to listenable mode on widget update',
      (tester) async {
        final notifier = ValueNotifier<DateTime?>(
          DateTime.now().add(const Duration(seconds: 2)),
        );

        await tester.pumpWidget(
          wrap(
            const PollingTimerIndicator(
              key: ValueKey('polling'),
              nextPollTime: null,
              nextPollTimeListenable: null,
              pollIntervalSeconds: 20,
            ),
          ),
        );

        await tester.pumpWidget(
          wrap(
            PollingTimerIndicator(
              key: const ValueKey('polling'),
              nextPollTime: DateTime.now().add(const Duration(seconds: 20)),
              nextPollTimeListenable: notifier,
              pollIntervalSeconds: 20,
            ),
          ),
        );

        await tester.pump();
        expect(secondsFromUi(tester), lessThanOrEqualTo(3));
      },
    );
  });
}
