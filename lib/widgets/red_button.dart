import 'package:flutter/material.dart';

class RedButton extends ElevatedButton {
  RedButton({super.key, required super.onPressed, required super.child})
    : super(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent,
          foregroundColor: Colors.white,
        ),
      );
}
