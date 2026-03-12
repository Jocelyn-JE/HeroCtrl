import 'package:flutter/material.dart';
import 'package:heroctrl/gopro_settings/camera_setting.dart';

class Fov extends CameraSetting {
  final double _factor;

  const Fov._(super._value, this._factor);

  double get factor => _factor;

  static const Fov wide = Fov._(0x00, 1.0);
  static const Fov medium = Fov._(0x01, 1.42);
  static const Fov narrow = Fov._(0x02, 2.0);

  static const List<Fov> all = [wide, medium, narrow];

  @override
  String getLocalizedName(BuildContext context) {
    final String factorStr = factor == factor.toInt()
        ? '${factor.toInt()}x'
        : '${factor.toStringAsFixed(2)}x';

    return factorStr;
  }

  static Fov fromByte(int byte) => enumFromByte(byte, all);
}
