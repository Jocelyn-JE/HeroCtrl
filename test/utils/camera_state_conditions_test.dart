import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heroctrl/gopro_settings/actions.dart';
import 'package:heroctrl/models/camera_state.dart';
import 'package:heroctrl/models/camera_status.dart';
import 'package:heroctrl/utils/camera_state_conditions.dart';

void main() {
  group('CameraStateConditions', () {
    CameraState createMockState({
      bool isCameraOn = true,
      bool isPreviewOn = true,
      CameraMode mode = CameraMode.videoMode,
      bool shutterDown = false,
    }) {
      final bytes = Uint8List(64);
      bytes[1] = mode.value;
      bytes[29] = shutterDown ? 0x01 : 0x00;
      final status = CameraStatus(bytes);
      final state = CameraState(status);
      state.isCameraOn = isCameraOn;
      state.isPreviewOn = isPreviewOn;
      return state;
    }

    group('isCameraOn', () {
      test('returns true when camera is on', () {
        final state = createMockState(isCameraOn: true);
        expect(CameraStateConditions.isCameraOn(state), isTrue);
      });

      test('returns false when camera is off', () {
        final state = createMockState(isCameraOn: false);
        expect(CameraStateConditions.isCameraOn(state), isFalse);
      });

      test('returns false when state is null', () {
        expect(CameraStateConditions.isCameraOn(null), isFalse);
      });
    });

    group('isPreviewOn', () {
      test('returns true when preview is on', () {
        final state = createMockState(isPreviewOn: true);
        expect(CameraStateConditions.isPreviewOn(state), isTrue);
      });

      test('returns false when preview is off', () {
        final state = createMockState(isPreviewOn: false);
        expect(CameraStateConditions.isPreviewOn(state), isFalse);
      });

      test('returns false when state is null', () {
        expect(CameraStateConditions.isPreviewOn(null), isFalse);
      });
    });

    group('isRecording', () {
      test('returns true when shutter is down in video mode', () {
        final state = createMockState(
          mode: CameraMode.videoMode,
          shutterDown: true,
        );
        expect(CameraStateConditions.isRecording(state), isTrue);
      });

      test('returns true when shutter is down in timelapse mode', () {
        final state = createMockState(
          mode: CameraMode.timelapseMode,
          shutterDown: true,
        );
        expect(CameraStateConditions.isRecording(state), isTrue);
      });

      test('returns false when shutter is up in video mode', () {
        final state = createMockState(
          mode: CameraMode.videoMode,
          shutterDown: false,
        );
        expect(CameraStateConditions.isRecording(state), isFalse);
      });

      test('returns false when shutter is down in photo mode', () {
        final state = createMockState(
          mode: CameraMode.photoMode,
          shutterDown: true,
        );
        expect(CameraStateConditions.isRecording(state), isFalse);
      });

      test('returns false when state is null', () {
        expect(CameraStateConditions.isRecording(null), isFalse);
      });
    });

    group('isShutterDown', () {
      test('returns true when shutter status is true', () {
        final state = createMockState(shutterDown: true);
        expect(CameraStateConditions.isShutterDown(state), isTrue);
      });

      test('returns false when shutter status is false', () {
        final state = createMockState(shutterDown: false);
        expect(CameraStateConditions.isShutterDown(state), isFalse);
      });

      test('returns false when state is null', () {
        expect(CameraStateConditions.isShutterDown(null), isFalse);
      });
    });

    group('isInSettingsMode', () {
      test('returns true when camera mode is settings', () {
        final state = createMockState(mode: CameraMode.settings);
        expect(CameraStateConditions.isInSettingsMode(state), isTrue);
      });

      test('returns false when camera mode is not settings', () {
        final state = createMockState(mode: CameraMode.videoMode);
        expect(CameraStateConditions.isInSettingsMode(state), isFalse);
      });

      test('returns false when state is null', () {
        expect(CameraStateConditions.isInSettingsMode(null), isFalse);
      });
    });

    group('isInPhotoOrBurstMode', () {
      test('returns true when in photo mode', () {
        final state = createMockState(mode: CameraMode.photoMode);
        expect(CameraStateConditions.isInPhotoOrBurstMode(state), isTrue);
      });

      test('returns true when in burst mode', () {
        final state = createMockState(mode: CameraMode.burstMode);
        expect(CameraStateConditions.isInPhotoOrBurstMode(state), isTrue);
      });

      test('returns false when in video mode', () {
        final state = createMockState(mode: CameraMode.videoMode);
        expect(CameraStateConditions.isInPhotoOrBurstMode(state), isFalse);
      });

      test('returns false when state is null', () {
        expect(CameraStateConditions.isInPhotoOrBurstMode(null), isFalse);
      });
    });

    group('isInVideoOrTimelapseMode', () {
      test('returns true when in video mode', () {
        final state = createMockState(mode: CameraMode.videoMode);
        expect(CameraStateConditions.isInVideoOrTimelapseMode(state), isTrue);
      });

      test('returns true when in timelapse mode', () {
        final state = createMockState(mode: CameraMode.timelapseMode);
        expect(CameraStateConditions.isInVideoOrTimelapseMode(state), isTrue);
      });

      test('returns false when in photo mode', () {
        final state = createMockState(mode: CameraMode.photoMode);
        expect(CameraStateConditions.isInVideoOrTimelapseMode(state), isFalse);
      });

      test('returns false when state is null', () {
        expect(CameraStateConditions.isInVideoOrTimelapseMode(null), isFalse);
      });
    });

    group('isInVideoMode', () {
      test('returns true when in video mode', () {
        final state = createMockState(mode: CameraMode.videoMode);
        expect(CameraStateConditions.isInVideoMode(state), isTrue);
      });

      test('returns false when not in video mode', () {
        final state = createMockState(mode: CameraMode.photoMode);
        expect(CameraStateConditions.isInVideoMode(state), isFalse);
      });

      test('returns false when state is null', () {
        expect(CameraStateConditions.isInVideoMode(null), isFalse);
      });
    });

    group('isInPhotoMode', () {
      test('returns true when in photo mode', () {
        final state = createMockState(mode: CameraMode.photoMode);
        expect(CameraStateConditions.isInPhotoMode(state), isTrue);
      });

      test('returns false when not in photo mode', () {
        final state = createMockState(mode: CameraMode.videoMode);
        expect(CameraStateConditions.isInPhotoMode(state), isFalse);
      });

      test('returns false when state is null', () {
        expect(CameraStateConditions.isInPhotoMode(null), isFalse);
      });
    });

    group('isInTimelapseMode', () {
      test('returns true when in timelapse mode', () {
        final state = createMockState(mode: CameraMode.timelapseMode);
        expect(CameraStateConditions.isInTimelapseMode(state), isTrue);
      });

      test('returns false when not in timelapse mode', () {
        final state = createMockState(mode: CameraMode.videoMode);
        expect(CameraStateConditions.isInTimelapseMode(state), isFalse);
      });

      test('returns false when state is null', () {
        expect(CameraStateConditions.isInTimelapseMode(null), isFalse);
      });
    });
  });

  group('isLandscape', () {
    testWidgets('returns true when orientation is landscape', (tester) async {
      tester.view.physicalSize = const Size(800, 600);
      tester.view.devicePixelRatio = 1.0;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              expect(isLandscape(context), isTrue);
              return Container();
            },
          ),
        ),
      );
      addTearDown(tester.view.reset);
    });

    testWidgets('returns false when orientation is portrait', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              expect(isLandscape(context), isFalse);
              return Container();
            },
          ),
        ),
      );
      addTearDown(tester.view.reset);
    });
  });
}
