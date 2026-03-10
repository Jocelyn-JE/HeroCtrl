import 'package:flutter/material.dart';
import 'package:heroctrl/constants/gopro_endpoints.dart';
import 'package:heroctrl/l10n/app_localizations.dart';

class PhotoResolution {
  final int _value;
  final Icon _icon;
  final PhotoZoom zoom;
  const PhotoResolution._(this._value, this._icon, this.zoom);

  int get value => _value;
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
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PhotoResolution && _value == other._value;

  @override
  int get hashCode => _value.hashCode;

  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (_value) {
      case 0x03:
        return l10n.photoResolution5MpMedium;
      case 0x04:
        return l10n.photoResolution7MpWide;
      case 0x05:
        return l10n.photoResolution12MpWide;
      case 0x06:
        return l10n.photoResolution7MpMedium;
      default:
        return toHex(_value);
    }
  }

  String getLocalizedMpName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (_value) {
      case 0x03:
        return l10n.photoResolution5Mp;
      case 0x04:
      case 0x06:
        return l10n.photoResolution7Mp;
      case 0x05:
        return l10n.photoResolution12Mp;
      default:
        return toHex(_value);
    }
  }
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

class TimelapseInterval {
  final int _value;
  const TimelapseInterval._(this._value);

  int get value => _value;

  static const TimelapseInterval halfASecond = TimelapseInterval._(0x00);
  static const TimelapseInterval oneSecond = TimelapseInterval._(0x01);
  static const TimelapseInterval twoSeconds = TimelapseInterval._(0x02);
  static const TimelapseInterval fiveSeconds = TimelapseInterval._(0x05);
  static const TimelapseInterval tenSeconds = TimelapseInterval._(0x0a);
  static const TimelapseInterval thirtySeconds = TimelapseInterval._(0x1e);
  static const TimelapseInterval sixtySeconds = TimelapseInterval._(0x3c);

  static const List<TimelapseInterval> all = [
    halfASecond,
    oneSecond,
    twoSeconds,
    fiveSeconds,
    tenSeconds,
    thirtySeconds,
    sixtySeconds,
  ];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimelapseInterval && _value == other._value;

  @override
  int get hashCode => _value.hashCode;

  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (_value) {
      case 0x00:
        return l10n.timelapse0_5Sec;
      case 0x01:
        return l10n.timelapse1Sec;
      case 0x02:
        return l10n.timelapse2Sec;
      case 0x05:
        return l10n.timelapse5Sec;
      case 0x0a:
        return l10n.timelapse10Sec;
      case 0x1e:
        return l10n.timelapse30Sec;
      case 0x3c:
        return l10n.timelapse60Sec;
      default:
        return toHex(_value);
    }
  }
}

class ContinuousShot {
  final int _value;
  const ContinuousShot._(this._value);

  int get value => _value;

  static const ContinuousShot off = ContinuousShot._(0x00);
  static const ContinuousShot threePhotos = ContinuousShot._(0x03);
  static const ContinuousShot fivePhotos = ContinuousShot._(0x05);
  static const ContinuousShot tenPhotos = ContinuousShot._(0x0a);

  static const List<ContinuousShot> all = [
    off,
    threePhotos,
    fivePhotos,
    tenPhotos,
  ];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContinuousShot && _value == other._value;

  @override
  int get hashCode => _value.hashCode;

  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (_value) {
      case 0x00:
        return l10n.volumeOff;
      case 0x03:
        return l10n.continuousShot3Photos;
      case 0x05:
        return l10n.continuousShot5Photos;
      case 0x0a:
        return l10n.continuousShot10Photos;
      default:
        return toHex(_value);
    }
  }
}

class BurstRate {
  final int _value;
  const BurstRate._(this._value);

  int get value => _value;

  static const BurstRate threePerSecond = BurstRate._(0x00);
  static const BurstRate fivePerSecond = BurstRate._(0x01);
  static const BurstRate tenPerSecond = BurstRate._(0x02);
  static const BurstRate tenPerTwoSeconds = BurstRate._(0x03);
  static const BurstRate thirtyPerSecond = BurstRate._(0x04);
  static const BurstRate thirtyPerTwoSeconds = BurstRate._(0x05);
  static const BurstRate thirtyPerThreeSeconds = BurstRate._(0x06);

  static const List<BurstRate> all = [
    threePerSecond,
    fivePerSecond,
    tenPerSecond,
    tenPerTwoSeconds,
    thirtyPerSecond,
    thirtyPerTwoSeconds,
    thirtyPerThreeSeconds,
  ];

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is BurstRate && _value == other._value;

  @override
  int get hashCode => _value.hashCode;

  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (_value) {
      case 0x00:
        return l10n.burstRate3PerSec;
      case 0x01:
        return l10n.burstRate5PerSec;
      case 0x02:
        return l10n.burstRate10PerSec;
      case 0x03:
        return l10n.burstRate10Per2Sec;
      case 0x04:
        return l10n.burstRate30PerSec;
      case 0x05:
        return l10n.burstRate30Per2Sec;
      case 0x06:
        return l10n.burstRate30Per3Sec;
      default:
        return toHex(_value);
    }
  }
}
