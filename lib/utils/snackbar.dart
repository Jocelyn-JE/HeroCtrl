import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String message, {Color? color}) {
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
}
