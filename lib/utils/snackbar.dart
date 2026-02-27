import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String message, {Color? color}) {
  if (!context.mounted) return;
  final messenger = ScaffoldMessenger.maybeOf(context);
  if (messenger == null) return;
  messenger.clearSnackBars();
  try {
    messenger.showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: Colors.white)),
        backgroundColor: color,
      ),
    );
  } catch (_) {
    // ScaffoldMessenger was deactivated before showSnackBar could execute
  }
}

void showSnackBarError(BuildContext context, String message) {
  showSnackBar(context, message, color: Colors.red);
}

void showSnackBarSuccess(BuildContext context, String message) {
  showSnackBar(context, message, color: Colors.green);
}

void showSnackBarWarning(BuildContext context, String message) {
  showSnackBar(context, message, color: Colors.orange);
}
