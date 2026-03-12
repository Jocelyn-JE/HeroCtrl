import 'package:flutter/material.dart';
import 'package:heroctrl/gopro_settings/camera_setting.dart';
import 'package:heroctrl/gopro_settings/endpoints.dart';
import 'package:heroctrl/gopro_settings/recording/fps.dart';
import 'package:heroctrl/l10n/app_localizations.dart';

class VideoStandard extends CameraSetting {
  const VideoStandard._(super._value);

  static const VideoStandard ntsc = VideoStandard._(0x00);
  static const VideoStandard pal = VideoStandard._(0x01);

  static const List<VideoStandard> all = [ntsc, pal];

  @override
  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (value) {
      case 0x00:
        return l10n.videoStandardNtsc;
      case 0x01:
        return l10n.videoStandardPal;
      default:
        return toHex(value);
    }
  }

  static final videoStandardFrameRates = {
    ntsc: [
      Fps.fps15,
      Fps.fps12,
      Fps.fps24,
      Fps.fps30,
      Fps.fps48,
      Fps.fps60,
      Fps.fps100,
      Fps.fps120,
      Fps.fps240,
    ],
    pal: [
      Fps.fps12_5,
      Fps.fps12,
      Fps.fps24,
      Fps.fps25,
      Fps.fps48,
      Fps.fps50,
      Fps.fps100,
      Fps.fps240,
    ],
  };

  static VideoStandard fromByte(int byte) => enumFromByte(byte, all);
}
