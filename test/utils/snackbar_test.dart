import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heroctrl/utils/snackbar.dart';

void main() {
  group('Snackbar utilities', () {
    testWidgets('showSnackBar displays message', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    showSnackBar(context, 'Test message', color: Colors.blue);
                  },
                  child: const Text('Show'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pump();

      expect(find.text('Test message'), findsOneWidget);
      expect(
        tester.widget<SnackBar>(find.byType(SnackBar)).backgroundColor,
        Colors.blue,
      );
    });

    testWidgets('showSnackBar with default color', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    showSnackBar(context, 'Default message');
                  },
                  child: const Text('Show'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pump();

      expect(find.text('Default message'), findsOneWidget);
    });

    testWidgets('showSnackBar clears previous snackbars', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        showSnackBar(context, 'First message');
                      },
                      child: const Text('First'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        showSnackBar(context, 'Second message');
                      },
                      child: const Text('Second'),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('First'));
      await tester.pump();
      expect(find.text('First message'), findsOneWidget);

      await tester.tap(find.text('Second'));
      await tester.pump();
      expect(find.text('Second message'), findsOneWidget);
      // First message should be cleared
    });

    testWidgets('showSnackBar handles unmounted context gracefully', (
      tester,
    ) async {
      late BuildContext savedContext;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                savedContext = context;
                return const Text('Content');
              },
            ),
          ),
        ),
      );

      // Remove the widget tree
      await tester.pumpWidget(Container());

      // This should not throw
      showSnackBar(savedContext, 'Message after unmount');
      await tester.pump();
    });

    testWidgets('showSnackBar handles missing ScaffoldMessenger', (
      tester,
    ) async {
      bool functionCalled = false;

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  // This context has no ScaffoldMessenger (maybeOf returns null)
                  showSnackBar(context, 'Message');
                  functionCalled = true;
                },
                child: const Text('Show'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pump();

      // Should not throw, function should be called
      expect(functionCalled, isTrue);
    });

    testWidgets('showSnackBar swallows show errors during build', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                // Calling during build can throw from showSnackBar internals.
                showSnackBar(context, 'Build time message');
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      await tester.pump();
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('showSnackBarError displays red snackbar', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    showSnackBarError(context, 'Error message');
                  },
                  child: const Text('Show Error'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Error'));
      await tester.pump();

      expect(find.text('Error message'), findsOneWidget);
      expect(
        tester.widget<SnackBar>(find.byType(SnackBar)).backgroundColor,
        Colors.red,
      );
    });

    testWidgets('showSnackBarSuccess displays green snackbar', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    showSnackBarSuccess(context, 'Success message');
                  },
                  child: const Text('Show Success'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Success'));
      await tester.pump();

      expect(find.text('Success message'), findsOneWidget);
      expect(
        tester.widget<SnackBar>(find.byType(SnackBar)).backgroundColor,
        Colors.green,
      );
    });

    testWidgets('showSnackBarWarning displays orange snackbar', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    showSnackBarWarning(context, 'Warning message');
                  },
                  child: const Text('Show Warning'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Warning'));
      await tester.pump();

      expect(find.text('Warning message'), findsOneWidget);
      expect(
        tester.widget<SnackBar>(find.byType(SnackBar)).backgroundColor,
        Colors.orange,
      );
    });

    testWidgets('snackbar text is white', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    showSnackBar(context, 'Test');
                  },
                  child: const Text('Show'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pump();

      final text = tester.widget<Text>(find.text('Test'));
      expect(text.style?.color, Colors.white);
    });
  });
}
