import 'package:flutter/material.dart';
import 'package:heroctrl/l10n/app_localizations.dart';
import 'package:heroctrl/services/gopro_connection_service.dart';
import 'package:heroctrl/utils/logger.dart';
import 'package:heroctrl/widgets/password_field.dart';

class ConnectionDialog extends StatefulWidget {
  final String ssid;
  final String bssid;

  const ConnectionDialog({super.key, required this.ssid, required this.bssid});

  @override
  State<ConnectionDialog> createState() => _ConnectionDialogState();
}

class _ConnectionDialogState extends State<ConnectionDialog> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleConnect() async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final localizations = AppLocalizations.of(context)!;

    setState(() => _isLoading = true);
    bool result = false;
    try {
      result = await GoProConnectionService.connectAndStore(
        widget.ssid,
        widget.bssid,
        _controller.text,
      );
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text(localizations.connectionError(e.toString())),
          backgroundColor: Colors.red,
        ),
      );
      AppLogger.error('Error connecting to ${widget.ssid}: $e');
      setState(() => _isLoading = false);
      return navigator.pop(result);
    }
    if (result != true) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text(localizations.connectionFailed(widget.ssid)),
          backgroundColor: Colors.red,
        ),
      );
    }
    navigator.pop(result);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(localizations.connectToCamera(widget.ssid)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_isLoading) ...[
            const CircularProgressIndicator(),
            const SizedBox(height: 8),
            Text(localizations.connectingToCamera, textAlign: TextAlign.center),
          ] else ...[
            PasswordField(controller: _controller),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(false),
          child: Text(localizations.cancel),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _handleConnect,
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text(localizations.connect),
        ),
      ],
    );
  }
}
