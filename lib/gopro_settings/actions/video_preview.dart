import 'package:flutter/material.dart';
import 'package:heroctrl/gopro_settings/camera_setting.dart';
import 'package:heroctrl/gopro_settings/endpoints.dart';
import 'package:heroctrl/l10n/app_localizations.dart';

class VideoPreview extends CameraSetting {
  const VideoPreview._(super._value);

  static const VideoPreview off = VideoPreview._(0x00);
  static const VideoPreview on = VideoPreview._(0x02);

  static const List<VideoPreview> all = [off, on];

  @override
  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (value) {
      case 0x00:
        return l10n.previewOff;
      case 0x02:
        return l10n.previewOn;
      default:
        return toHex(value);
    }
  }

  static VideoPreview fromByte(int byte) => enumFromByte(byte, all);
}
