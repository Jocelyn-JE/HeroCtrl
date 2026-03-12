import 'package:flutter/material.dart';

abstract class EnumClass {
  final int _value;

  const EnumClass(this._value);

  int get value => _value;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is EnumClass &&
            runtimeType == other.runtimeType &&
            _value == other._value;
  }

  @override
  int get hashCode => _value.hashCode;

  String getLocalizedName(BuildContext context);
}

T enumFromByte<T extends EnumClass>(int byte, List<T> all) {
  assert(all.isNotEmpty, 'all must not be empty');
  return all.firstWhere((e) => e.value == byte, orElse: () => all.first);
}
