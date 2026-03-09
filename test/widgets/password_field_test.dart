import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heroctrl/widgets/password_field.dart';
import 'package:heroctrl/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  Widget createTestableWidget(Widget child) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    );
  }

  group('PasswordField', () {
    testWidgets('renders password field with default label', (tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        createTestableWidget(PasswordField(controller: controller)),
      );

      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
    });

    testWidgets('obscures text by default', (tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        createTestableWidget(PasswordField(controller: controller)),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.obscureText, isTrue);
    });

    testWidgets('toggles password visibility when icon is tapped', (
      tester,
    ) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        createTestableWidget(PasswordField(controller: controller)),
      );

      // Initially obscured
      TextField textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.obscureText, isTrue);
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);

      // Tap visibility toggle
      await tester.tap(find.byIcon(Icons.visibility_off));
      await tester.pump();

      // Now visible
      textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.obscureText, isFalse);
      expect(find.byIcon(Icons.visibility), findsOneWidget);

      // Tap again to hide
      await tester.tap(find.byIcon(Icons.visibility));
      await tester.pump();

      // Obscured again
      textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.obscureText, isTrue);
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    });

    testWidgets('uses custom label when provided', (tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        createTestableWidget(
          PasswordField(controller: controller, labelText: 'Custom Password'),
        ),
      );

      expect(find.text('Custom Password'), findsOneWidget);
    });

    testWidgets('accepts text input', (tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        createTestableWidget(PasswordField(controller: controller)),
      );

      await tester.enterText(find.byType(TextField), 'test123');
      expect(controller.text, equals('test123'));
    });

    testWidgets('calls onChanged when text changes', (tester) async {
      final controller = TextEditingController();
      String? changedValue;

      await tester.pumpWidget(
        createTestableWidget(
          PasswordField(
            controller: controller,
            onChanged: (value) => changedValue = value,
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'newpass');
      expect(changedValue, equals('newpass'));
    });

    testWidgets('calls onEditingComplete when enter is pressed', (
      tester,
    ) async {
      final controller = TextEditingController();
      bool completeCalled = false;

      await tester.pumpWidget(
        createTestableWidget(
          PasswordField(
            controller: controller,
            onEditingComplete: () => completeCalled = true,
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'password');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      expect(completeCalled, isTrue);
    });
  });
}
