import 'package:flutter/material.dart';
import 'package:heroctrl/l10n/app_localizations.dart';
import 'package:heroctrl/models/camera_serial_and_mac.dart';
import 'package:heroctrl/models/camera_version.dart';
import 'package:heroctrl/models/camera_wifi_info.dart';
import 'package:heroctrl/services/gopro_api_service.dart';
import 'package:heroctrl/utils/logger.dart';
import 'package:heroctrl/utils/snackbar.dart';

class CameraInfoCard extends StatefulWidget {
  final String password;

  const CameraInfoCard({super.key, required this.password});

  @override
  State<CameraInfoCard> createState() => _CameraInfoCardState();
}

class _CameraInfoCardState extends State<CameraInfoCard> {
  CameraSerialAndMac? _cameraSerialAndMac;
  CameraVersion? _cameraVersion;
  CameraWifiInfo? _cameraWifiInfo;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCameraInfo();
  }

  Future<void> _fetchCameraInfo() async {
    try {
      final serialAndMac = await GoProApiService.getSerialAndMacAddress(
        widget.password,
      );
      final version = await GoProApiService.getVersion(widget.password);
      final wifiInfo = await GoProApiService.getCameraWifiInfo(widget.password);
      if (mounted) {
        setState(() {
          _cameraSerialAndMac = serialAndMac;
          _cameraVersion = version;
          _cameraWifiInfo = wifiInfo;
          _isLoading = false;
        });
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching camera info', e, stackTrace);
      if (mounted) {
        setState(() => _isLoading = false);
        showSnackBar(
          context,
          'Error fetching camera info: $e',
          color: Colors.red,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.cameraInfoTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            if (_isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              )
            else ...[
              if (_cameraVersion != null) ...[
                Text(
                  localizations.cameraModel(_cameraVersion!.cameraType),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  localizations.cameraVersion(_cameraVersion!.firmwareVersion),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
              if (_cameraSerialAndMac != null) ...[
                Text(
                  localizations.cameraSerial(_cameraSerialAndMac!.serialNumber),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  localizations.cameraMacAddress(
                    _cameraSerialAndMac!.macAddress,
                  ),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
              if (_cameraWifiInfo != null) ...[
                Text(
                  localizations.cameraWifiSSID(_cameraWifiInfo!.ssid),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  localizations.cameraWifiPassword(_cameraWifiInfo!.password),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
