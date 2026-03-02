import 'package:flutter/material.dart';
import 'package:heroctrl/l10n/app_localizations.dart';
import 'package:heroctrl/services/gopro_api_service.dart';
import 'package:heroctrl/utils/logger.dart';
import 'package:heroctrl/utils/snackbar.dart';

class OrientationSettingCard extends StatefulWidget {
  final String password;

  const OrientationSettingCard({super.key, required this.password});

  @override
  State<OrientationSettingCard> createState() => _OrientationSettingCardState();
}

class _OrientationSettingCardState extends State<OrientationSettingCard> {
  bool? _upsideDown;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOrientationSetting();
  }

  Future<void> _fetchOrientationSetting() async {
    try {
      final upsideDown = await GoProApiService.isUpsideDown(widget.password);
      if (mounted) {
        setState(() {
          _upsideDown = upsideDown;
          _isLoading = false;
        });
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching orientation setting', e, stackTrace);
      if (mounted) {
        setState(() => _isLoading = false);
        showSnackBarError(context, 'Error fetching orientation setting: $e');
      }
    }
  }

  Future<void> _setOrientation(bool upsideDown) async {
    final previous = _upsideDown;
    setState(() => _upsideDown = upsideDown);
    try {
      await GoProApiService.setOrientation(widget.password, upsideDown);
    } catch (e, stackTrace) {
      AppLogger.error('Error setting orientation', e, stackTrace);
      if (mounted) {
        setState(() => _upsideDown = previous);
        showSnackBarError(context, 'Error setting orientation: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizations.orientationUpsideDown,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    localizations.orientationUpsideDownSubtitle,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
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
            else
              Align(
                alignment: Alignment.centerRight,
                child: Switch(
                  value: _upsideDown ?? false,
                  onChanged: _setOrientation,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
