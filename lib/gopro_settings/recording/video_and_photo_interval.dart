import 'package:flutter/material.dart';
import 'package:heroctrl/gopro_settings/camera_setting.dart';
import 'package:heroctrl/gopro_settings/endpoints.dart';
import 'package:heroctrl/l10n/app_localizations.dart';

class VideoAndPhotoInterval extends CameraSetting {
  const VideoAndPhotoInterval._(super._value);

  static const VideoAndPhotoInterval off = VideoAndPhotoInterval._(0x00);
  static const VideoAndPhotoInterval every5s = VideoAndPhotoInterval._(0x01);
  static const VideoAndPhotoInterval every10s = VideoAndPhotoInterval._(0x02);
  static const VideoAndPhotoInterval every30s = VideoAndPhotoInterval._(0x03);
  static const VideoAndPhotoInterval every60s = VideoAndPhotoInterval._(0x04);

  static const List<VideoAndPhotoInterval> all = [
    off,
    every5s,
    every10s,
    every30s,
    every60s,
  ];

  @override
  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (value) {
      case 0x00:
        return l10n.volumeOff;
      case 0x01:
        return l10n.videoAndPhotoEvery5s;
      case 0x02:
        return l10n.videoAndPhotoEvery10s;
      case 0x03:
        return l10n.videoAndPhotoEvery30s;
      case 0x04:
        return l10n.videoAndPhotoEvery60s;
      default:
        return toHex(value);
    }
  }

  static VideoAndPhotoInterval fromByte(int byte) => enumFromByte(byte, all);
}
