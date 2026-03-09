import 'package:flutter_test/flutter_test.dart';
import 'package:heroctrl/constants/gopro_recording_enums.dart';
import 'package:heroctrl/constants/gopro_system_enums.dart';

void main() {
  group('VideoResolution', () {
    test('getSupportedFPS returns correct FPS for resolution and standard', () {
      // 1080p NTSC should support 24, 30, 48, 60 fps
      final ntsc1080 = VideoResolution.getSupportedFPS(
        VideoResolution.res1080p,
        VideoStandard.ntsc,
      );
      expect(ntsc1080, contains(FPS.fps24));
      expect(ntsc1080, contains(FPS.fps30));
      expect(ntsc1080, contains(FPS.fps48));
      expect(ntsc1080, contains(FPS.fps60));
      expect(ntsc1080, isNot(contains(FPS.fps25)));
      expect(ntsc1080, isNot(contains(FPS.fps50)));

      // 1080p PAL should support 24, 25, 48, 50 fps
      final pal1080 = VideoResolution.getSupportedFPS(
        VideoResolution.res1080p,
        VideoStandard.pal,
      );
      expect(pal1080, contains(FPS.fps24));
      expect(pal1080, contains(FPS.fps25));
      expect(pal1080, contains(FPS.fps48));
      expect(pal1080, contains(FPS.fps50));
      expect(pal1080, isNot(contains(FPS.fps30)));
      expect(pal1080, isNot(contains(FPS.fps60)));
    });

    test('720p returns different FPS for NTSC and PAL', () {
      final ntsc720 = VideoResolution.getSupportedFPS(
        VideoResolution.res720p,
        VideoStandard.ntsc,
      );
      expect(ntsc720, equals([FPS.fps60, FPS.fps120]));

      final pal720 = VideoResolution.getSupportedFPS(
        VideoResolution.res720p,
        VideoStandard.pal,
      );
      expect(pal720, equals([FPS.fps50, FPS.fps100]));
    });

    test('getSupportedFOV returns correct FOV for resolution', () {
      // 1080p supports wide, medium, narrow
      final fov1080 = VideoResolution.getSupportedFOV(
        VideoResolution.res1080p,
        FPS.fps30,
      );
      expect(fov1080, contains(FOV.wide));
      expect(fov1080, contains(FOV.medium));
      expect(fov1080, contains(FOV.narrow));

      // 4K only supports wide
      final fov4k = VideoResolution.getSupportedFOV(
        VideoResolution.res4k,
        FPS.fps15,
      );
      expect(fov4k, equals([FOV.wide]));
    });

    test('720p at high FPS only supports wide and narrow FOV', () {
      final fov120 = VideoResolution.getSupportedFOV(
        VideoResolution.res720p,
        FPS.fps120,
      );
      expect(fov120, equals([FOV.wide, FOV.narrow]));
      expect(fov120, isNot(contains(FOV.medium)));
    });

    test('aspect ratios are correct', () {
      expect(VideoResolution.res1080p.aspectRatio, equals(16 / 9));
      expect(VideoResolution.res1440p.aspectRatio, equals(4 / 3));
      expect(VideoResolution.res4k.aspectRatio, equals(16 / 9));
    });

    test('all resolutions have valid values', () {
      for (final res in VideoResolution.all) {
        expect(res.value, greaterThanOrEqualTo(0));
        expect(res.aspectRatio, greaterThan(0));
      }
    });
  });

  group('FOV', () {
    test('has correct zoom factors', () {
      expect(FOV.wide.factor, equals(1.0));
      expect(FOV.medium.factor, equals(1.42));
      expect(FOV.narrow.factor, equals(2.0));
    });

    test('all FOV options are defined', () {
      expect(FOV.all.length, equals(3));
      expect(FOV.all, contains(FOV.wide));
      expect(FOV.all, contains(FOV.medium));
      expect(FOV.all, contains(FOV.narrow));
    });
  });

  group('FPS', () {
    test('all FPS values are unique', () {
      final values = FPS.all.map((fps) => fps.value).toSet();
      expect(values.length, equals(FPS.all.length));
    });

    test('FPS values are in expected range', () {
      for (final fps in FPS.all) {
        expect(fps.value, greaterThanOrEqualTo(0));
        expect(fps.value, lessThanOrEqualTo(0x0b));
      }
    });
  });

  group('LoopVideoDuration', () {
    test('all duration options are defined', () {
      expect(LoopVideoDuration.all.length, equals(6));
      expect(LoopVideoDuration.all, contains(LoopVideoDuration.off));
      expect(LoopVideoDuration.all, contains(LoopVideoDuration.fiveMinutes));
      expect(LoopVideoDuration.all, contains(LoopVideoDuration.twentyMinutes));
      expect(LoopVideoDuration.all, contains(LoopVideoDuration.oneHour));
      expect(LoopVideoDuration.all, contains(LoopVideoDuration.twoHours));
      expect(LoopVideoDuration.all, contains(LoopVideoDuration.maxStorage));
    });
  });
}
