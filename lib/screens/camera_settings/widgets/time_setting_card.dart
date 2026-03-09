import 'dart:async';
import 'package:flutter/material.dart';
import 'package:heroctrl/l10n/app_localizations.dart';
import 'package:heroctrl/services/gopro_api_service.dart';
import 'package:heroctrl/utils/logger.dart';
import 'package:heroctrl/utils/snackbar.dart';
import 'package:intl/intl.dart';

class TimeSettingCard extends StatefulWidget {
  final String password;

  const TimeSettingCard({super.key, required this.password});

  @override
  State<TimeSettingCard> createState() => _TimeSettingCardState();
}

class _TimeSettingCardState extends State<TimeSettingCard> {
  DateTime? _cameraTime;
  bool _isLoading = true;
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _fetchTimeSetting();
  }

  Future<void> _fetchTimeSetting() async {
    try {
      final time = await GoProApiService.getTime(widget.password);
      if (mounted) {
        setState(() {
          _cameraTime = time;
          _isLoading = false;
        });
        _startTicker();
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching time setting', e, stackTrace);
      if (mounted) {
        setState(() => _isLoading = false);
        showSnackBarError(context, 'Error fetching time setting: $e');
      }
    }
  }

  Future<void> _setTime(DateTime value) async {
    _ticker?.cancel();
    final previous = _cameraTime;
    setState(() => _cameraTime = value);
    try {
      await GoProApiService.setTime(widget.password, value);
      _startTicker();
    } catch (e, stackTrace) {
      AppLogger.error('Error setting time: $e', e, stackTrace);
      if (mounted) {
        setState(() => _cameraTime = previous);
        _startTicker();
        showSnackBarError(context, 'Error setting time: $e');
      }
    }
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(
          () => _cameraTime = _cameraTime!.add(const Duration(seconds: 1)),
        );
      }
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.timeSetting,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              l10n.timeSettingSubtitle,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.access_time, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        '${l10n.cameraCurrentTime}: '
                        '${DateFormat('yyyy-MM-dd  HH:mm:ss').format(_cameraTime!)}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _setTime(DateTime.now()),
                      child: Text(l10n.timeSetToNow),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
