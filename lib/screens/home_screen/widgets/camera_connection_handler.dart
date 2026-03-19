import 'package:flutter/material.dart';
import 'package:heroctrl/models/gopro_registration.dart';
import 'package:heroctrl/services/gopro_api_service.dart';
import 'package:heroctrl/services/gopro_connection_service.dart';
import 'package:heroctrl/utils/logger.dart';
import 'package:heroctrl/utils/snackbar.dart';
import 'connection_loading_dialog.dart';

class CameraConnectionHandler {
  static Future<void> connect(
    BuildContext context,
    GoProRegistration camera,
  ) async {
    if (!context.mounted) return;

    if (!await _isWifiEnabled()) {
      if (!context.mounted) return;
      showSnackBarError(
        context,
        'Wi-Fi is turned off. Please enable Wi-Fi and try again.',
      );
      return;
    }

    bool connectionCancelled = false;

    if (!context.mounted) return;
    // Show loading dialog with cancel button
    ConnectionLoadingDialog.show(
      context,
      onCancel: () {
        connectionCancelled = true;
        Navigator.of(context).pop();
      },
    );

    // Attempt connection
    bool connected = false;
    try {
      connected = await GoProConnectionService.connectToRegisteredGoPro(camera);
    } catch (e, stackTrace) {
      AppLogger.error('Error while connecting to camera', e, stackTrace);
      if (!context.mounted) return;
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      await _handleFailedConnection(context);
      return;
    }

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

    try {
      if (connected) {
        await _handleSuccessfulConnection(context, camera);
      } else {
        await _handleFailedConnection(context);
      }
    } catch (e, stackTrace) {
      // If verification fails, treat as failed connection
      AppLogger.error('Connection verification failed: $e', e, stackTrace);
      if (connected) {
        await GoProConnectionService.disconnect(instant: true);
      }
      if (!context.mounted) return;
      await _handleFailedConnection(context);
      return;
    }
  }

  static Future<void> _handleSuccessfulConnection(
    BuildContext context,
    GoProRegistration camera,
  ) async {
    if (!context.mounted) return;

    await GoProApiService.turnOnCamera(camera.password);
    if (!context.mounted) return;
    showSnackBarSuccess(context, 'Successfully connected to camera');
    await Navigator.pushNamed(context, '/control');
  }

  static Future<void> _handleFailedConnection(BuildContext context) async {
    if (!context.mounted) return;
    if (!await _isWifiEnabled()) {
      if (!context.mounted) return;
      showSnackBarError(
        context,
        'Wi-Fi is turned off. Please enable Wi-Fi and try again.',
      );
      return;
    }
    if (!context.mounted) return;
    showSnackBarError(
      context,
      'Failed to connect to camera. Make sure the camera is powered on and its Wi-Fi is enabled, then try again.',
    );
  }

  static Future<bool> _isWifiEnabled() async {
    try {
      return await GoProConnectionService.isWifiEnabled();
    } catch (e, stackTrace) {
      AppLogger.error('Could not check Wi-Fi state', e, stackTrace);
      // Do not block connection attempts if state cannot be read.
      return true;
    }
  }
}
