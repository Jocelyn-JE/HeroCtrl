import 'package:flutter/material.dart';
import 'package:heroctrl/gopro_settings/photo.dart';
import 'package:heroctrl/models/camera_state.dart';
import 'package:heroctrl/services/gopro_api_service.dart';
import 'package:heroctrl/utils/logger.dart';

class BurstRateSelector extends StatelessWidget {
  final CameraState cameraState;
  final String password;
  final Future<void> Function() onBurstRateChanged;
  final EdgeInsetsGeometry padding;

  const BurstRateSelector({
    super.key,
    required this.cameraState,
    required this.password,
    required this.onBurstRateChanged,
    this.padding = const EdgeInsets.all(8.0),
  });

  @override
  Widget build(BuildContext context) {
    final BurstRate currentBurstRate = cameraState.status.burstRate;

    final BurstRate? selectedValue = BurstRate.all.contains(currentBurstRate)
        ? currentBurstRate
        : null;

    return Padding(
      padding: padding,
      child: DropdownButton<BurstRate>(
        isExpanded: true,
        value: selectedValue,
        onChanged: cameraState.isCameraOn
            ? (newValue) {
                if (newValue != null) {
                  AppLogger.info(
                    'Changing burst rate to ${newValue.getLocalizedName(context)}',
                  );
                  GoProApiService.setBurstRate(password, newValue).then((_) {
                    onBurstRateChanged();
                  });
                }
              }
            : null,
        items: BurstRate.all
            .map(
              (rate) => DropdownMenuItem(
                value: rate,
                child: Text(rate.getLocalizedName(context)),
              ),
            )
            .toList(),
      ),
    );
  }
}
