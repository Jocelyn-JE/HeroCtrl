import 'package:flutter_test/flutter_test.dart';
import 'package:heroctrl/gopro_settings/recording/recording.dart';
import 'package:heroctrl/gopro_settings/system/system.dart';

void main() {
  group('VideoResolution', () {
    test('getSupportedFps returns correct FPS for resolution and standard', () {
      // 1080p NTSC should support 24, 30, 48, 60 fps
      final ntsc1080 = VideoResolution.getSupportedFps(
        VideoResolution.res1080p,
        VideoStandard.ntsc,
      );
      expect(ntsc1080, contains(Fps.fps24));
      expect(ntsc1080, contains(Fps.fps30));
      expect(ntsc1080, contains(Fps.fps48));
      expect(ntsc1080, contains(Fps.fps60));
      expect(ntsc1080, isNot(contains(Fps.fps25)));
      expect(ntsc1080, isNot(contains(Fps.fps50)));

      // 1080p PAL should support 24, 25, 48, 50 fps
      final pal1080 = VideoResolution.getSupportedFps(
        VideoResolution.res1080p,
        VideoStandard.pal,
      );
      expect(pal1080, contains(Fps.fps24));
      expect(pal1080, contains(Fps.fps25));
      expect(pal1080, contains(Fps.fps48));
      expect(pal1080, contains(Fps.fps50));
      expect(pal1080, isNot(contains(Fps.fps30)));
      expect(pal1080, isNot(contains(Fps.fps60)));
    });

    test('720p returns different FPS for NTSC and PAL', () {
      final ntsc720 = VideoResolution.getSupportedFps(
        VideoResolution.res720p,
        VideoStandard.ntsc,
      );
      expect(ntsc720, equals([Fps.fps60, Fps.fps120]));

      final pal720 = VideoResolution.getSupportedFps(
        VideoResolution.res720p,
        VideoStandard.pal,
      );
      expect(pal720, equals([Fps.fps50, Fps.fps100]));
    });

    test('getSupportedFov returns correct FOV for resolution', () {
      // 1080p supports wide, medium, narrow
      final fov1080 = VideoResolution.getSupportedFov(
        VideoResolution.res1080p,
        Fps.fps30,
      );
      expect(fov1080, contains(Fov.wide));
      expect(fov1080, contains(Fov.medium));
      expect(fov1080, contains(Fov.narrow));

      // 4K only supports wide
      final fov4k = VideoResolution.getSupportedFov(
        VideoResolution.res4k,
        Fps.fps15,
      );
      expect(fov4k, equals([Fov.wide]));
    });

    test('720p at high FPS only supports wide and narrow FOV', () {
      final fov120 = VideoResolution.getSupportedFov(
        VideoResolution.res720p,
        Fps.fps120,
      );
      expect(fov120, equals([Fov.wide, Fov.narrow]));
      expect(fov120, isNot(contains(Fov.medium)));
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
      expect(Fov.wide.factor, equals(1.0));
      expect(Fov.medium.factor, equals(1.42));
      expect(Fov.narrow.factor, equals(2.0));
    });

    test('all FOV options are defined', () {
      expect(Fov.all.length, equals(3));
      expect(Fov.all, contains(Fov.wide));
      expect(Fov.all, contains(Fov.medium));
      expect(Fov.all, contains(Fov.narrow));
    });
  });

  group('FPS', () {
    test('all FPS values are unique', () {
      final values = Fps.all.map((fps) => fps.value).toSet();
      expect(values.length, equals(Fps.all.length));
    });

    test('FPS values are in expected range', () {
      for (final fps in Fps.all) {
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
