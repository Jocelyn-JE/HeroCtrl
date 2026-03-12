import 'package:flutter/material.dart';

abstract class CameraSetting {
  final int _value;

  const CameraSetting(this._value);

  int get value => _value;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is CameraSetting &&
            runtimeType == other.runtimeType &&
            _value == other._value;
  }

  @override
  int get hashCode => _value.hashCode;

  String getLocalizedName(BuildContext context);
}

T enumFromByte<T extends CameraSetting>(int byte, List<T> all) {
  assert(all.isNotEmpty, 'all must not be empty');
  return all.firstWhere((e) => e.value == byte, orElse: () => all.first);
}
