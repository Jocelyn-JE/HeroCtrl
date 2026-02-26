import 'package:flutter/material.dart';
import 'package:heroctrl/models/gopro_registration.dart';
import 'package:heroctrl/services/gopro_api_service.dart';
import 'package:heroctrl/services/gopro_connection_service.dart';
import 'package:heroctrl/utils/snackbar.dart';
import 'connection_loading_dialog.dart';

class CameraConnectionHandler {
  static Future<void> connect(
    BuildContext context,
    GoProRegistration camera,
  ) async {
    if (!context.mounted) return;

    bool connectionCancelled = false;

    // Show loading dialog with cancel button
    ConnectionLoadingDialog.show(
      context,
      onCancel: () {
        connectionCancelled = true;
        Navigator.of(context).pop();
      },
    );

    // Attempt connection
    final bool connected =
        await GoProConnectionService.connectToRegisteredGoPro(camera);

    // Dismiss loading dialog if still showing
    if (!context.mounted) return;
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }

    // If user cancelled, disconnect and return
    if (connectionCancelled) {
      if (connected) {
        await GoProConnectionService.disconnect(instant: true);
      }
      return;
    }

    if (connected) {
      await _handleSuccessfulConnection(context, camera);
    } else {
      await _handleFailedConnection(context);
    }
  }

  static Future<void> _handleSuccessfulConnection(
    BuildContext context,
    GoProRegistration camera,
  ) async {
    if (!context.mounted) return;

    showSnackBarSuccess(context, 'Successfully connected to camera');
    await GoProApiService.turnOnCamera(camera.password);
    if (!context.mounted) return;
    await Navigator.pushNamed(context, '/control');
  }

  static Future<void> _handleFailedConnection(BuildContext context) async {
    if (!context.mounted) return;
    showSnackBarError(context, 'Failed to connect to camera');
  }
}
