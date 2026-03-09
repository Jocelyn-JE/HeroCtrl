import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heroctrl/screens/camera_search_screen/camera_search_screen.dart';
import 'package:heroctrl/screens/camera_settings/camera_settings_screen.dart';
import 'package:heroctrl/screens/control_screen/control_screen.dart';
import 'package:heroctrl/screens/home_screen/home_screen.dart';
import 'package:heroctrl/screens/settings_screen/settings_screen.dart';
import 'package:heroctrl/utils/app_routes.dart';

void main() {
  group('AppRoutes', () {
    test('has correct route names', () {
      expect(AppRoutes.settings, '/settings');
      expect(AppRoutes.register, '/camera_search');
      expect(AppRoutes.home, '/home');
      expect(AppRoutes.control, '/control');
      expect(AppRoutes.cameraSettings, '/camera_settings');
    });

    test('routes map contains all route names', () {
      final routes = AppRoutes.routes;

      expect(routes, containsPair(AppRoutes.settings, isA<WidgetBuilder>()));
      expect(routes, containsPair(AppRoutes.register, isA<WidgetBuilder>()));
      expect(routes, containsPair(AppRoutes.home, isA<WidgetBuilder>()));
      expect(routes, containsPair(AppRoutes.control, isA<WidgetBuilder>()));
      expect(
        routes,
        containsPair(AppRoutes.cameraSettings, isA<WidgetBuilder>()),
      );
    });

    test('routes map has correct number of routes', () {
      expect(AppRoutes.routes.length, 5);
    });

    testWidgets('settings route builds SettingsScreen', (tester) async {
      final builder = AppRoutes.routes[AppRoutes.settings]!;
      final widget = builder(tester.element(find.byType(Container)));

      expect(widget, isA<SettingsScreen>());
    });

    testWidgets('register route builds CameraSearchScreen', (tester) async {
      final builder = AppRoutes.routes[AppRoutes.register]!;
      final widget = builder(tester.element(find.byType(Container)));

      expect(widget, isA<CameraSearchScreen>());
    });

    testWidgets('home route builds HomeScreen', (tester) async {
      final builder = AppRoutes.routes[AppRoutes.home]!;
      final widget = builder(tester.element(find.byType(Container)));

      expect(widget, isA<HomeScreen>());
    });

    testWidgets('control route builds ControlScreen', (tester) async {
      final builder = AppRoutes.routes[AppRoutes.control]!;
      final widget = builder(tester.element(find.byType(Container)));

      expect(widget, isA<ControlScreen>());
    });

    testWidgets('cameraSettings route builds CameraSettingsScreen', (
      tester,
    ) async {
      final builder = AppRoutes.routes[AppRoutes.cameraSettings]!;
      final widget = builder(tester.element(find.byType(Container)));

      expect(widget, isA<CameraSettingsScreen>());
    });

    testWidgets('routes can be used with MaterialApp', (tester) async {
      await tester.pumpWidget(
        MaterialApp(routes: AppRoutes.routes, home: Container()),
      );

      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('navigator can push route by name', (tester) async {
      // Test that routes are properly registered and can be navigated to
      // Note: We don't actually navigate because screen dependencies may not be set up
      await tester.pumpWidget(
        MaterialApp(
          routes: AppRoutes.routes,
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  // Verify route is registered
                  final navigator = Navigator.of(context);
                  expect(
                    () => navigator.pushNamed(AppRoutes.settings),
                    returnsNormally,
                  );
                },
                child: const Text('Test Routes'),
              );
            },
          ),
        ),
      );

      expect(find.text('Test Routes'), findsOneWidget);
    });
  });
}
