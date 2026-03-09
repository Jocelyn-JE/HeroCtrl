import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heroctrl/widgets/red_button.dart';

void main() {
  Widget wrap(Widget child) {
    return MaterialApp(
      home: Scaffold(body: Center(child: child)),
    );
  }

  group('RedButton', () {
    testWidgets('renders provided child', (tester) async {
      await tester.pumpWidget(
        wrap(RedButton(onPressed: () {}, child: const Text('Delete'))),
      );

      expect(find.byType(RedButton), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
    });

    testWidgets('invokes onPressed when tapped', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        wrap(
          RedButton(
            onPressed: () {
              tapped = true;
            },
            child: const Text('Tap Me'),
          ),
        ),
      );

      await tester.tap(find.text('Tap Me'));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('applies red accent background and white foreground', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(RedButton(onPressed: () {}, child: const Text('Styled'))),
      );

      final button = tester.widget<RedButton>(find.byType(RedButton));
      final backgroundColor = button.style?.backgroundColor?.resolve({});
      final foregroundColor = button.style?.foregroundColor?.resolve({});

      expect(backgroundColor, Colors.redAccent);
      expect(foregroundColor, Colors.white);
    });
  });
}
