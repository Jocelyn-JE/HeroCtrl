import 'package:flutter/material.dart';
import 'package:heroctrl/gopro_settings/camera_setting.dart';
import 'package:heroctrl/gopro_settings/endpoints.dart';
import 'package:heroctrl/l10n/app_localizations.dart';

class PhotoResolution extends CameraSetting {
  final Icon _icon;
  final PhotoZoom zoom;
  const PhotoResolution._(super.value, this._icon, this.zoom);

  Icon get icon => _icon;

  static const PhotoResolution res5MPmedium = PhotoResolution._(
    0x03,
    Icon(Icons.five_mp),
    PhotoZoom.medium,
  );
  static const PhotoResolution res7MPwide = PhotoResolution._(
    0x04,
    Icon(Icons.seven_mp),
    PhotoZoom.wide,
  );
  static const PhotoResolution res12MPwide = PhotoResolution._(
    0x05,
    Icon(Icons.twelve_mp),
    PhotoZoom.wide,
  );
  static const PhotoResolution res7MPmedium = PhotoResolution._(
    0x06,
    Icon(Icons.seven_mp),
    PhotoZoom.medium,
  );

  static const List<PhotoResolution> all = [
    res5MPmedium,
    res7MPwide,
    res12MPwide,
    res7MPmedium,
  ];

  static List<PhotoResolution> forZoom(PhotoZoom zoom) {
    switch (zoom) {
      case PhotoZoom.wide:
        return [res7MPwide, res12MPwide];
      case PhotoZoom.medium:
        return [res7MPmedium, res5MPmedium];
    }
  }

  @override
  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (value) {
      case 0x03:
        return l10n.photoResolution5MpMedium;
      case 0x04:
        return l10n.photoResolution7MpWide;
      case 0x05:
        return l10n.photoResolution12MpWide;
      case 0x06:
        return l10n.photoResolution7MpMedium;
      default:
        return toHex(value);
    }
  }

  String getLocalizedMpName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (value) {
      case 0x03:
        return l10n.photoResolution5Mp;
      case 0x04:
      case 0x06:
        return l10n.photoResolution7Mp;
      case 0x05:
        return l10n.photoResolution12Mp;
      default:
        return toHex(value);
    }
  }

  static PhotoResolution fromByte(int byte) => enumFromByte(byte, all);
}

enum PhotoZoom {
  wide,
  medium;

  IconData get icon => switch (this) {
    PhotoZoom.wide => Icons.one_x_mobiledata,
    PhotoZoom.medium => Icons.zoom_in,
  };

  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return switch (this) {
      PhotoZoom.wide => l10n.photoZoomWide,
      PhotoZoom.medium => l10n.photoZoomMedium,
    };
  }
}
