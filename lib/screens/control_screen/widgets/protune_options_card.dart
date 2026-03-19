import 'package:flutter/material.dart';
import 'package:heroctrl/gopro_settings/protune/protune.dart';
import 'package:heroctrl/models/camera_state.dart';
import 'package:heroctrl/services/gopro_api_service.dart';
import 'package:heroctrl/utils/logger.dart';

class ProTuneOptionsCard extends StatelessWidget {
  final CameraState cameraState;
  final String password;
  final Future<void> Function() onSettingChanged;

  const ProTuneOptionsCard({
    super.key,
    required this.cameraState,
    required this.password,
    required this.onSettingChanged,
  });

  Future<void> _setWhiteBalance(WhiteBalance option) async {
    try {
      await GoProApiService.setWhiteBalance(password, option);
      await onSettingChanged();
    } catch (error, stackTrace) {
      AppLogger.error('Error setting white balance', error, stackTrace);
    }
  }

  Future<void> _setSharpness(Sharpness option) async {
    try {
      await GoProApiService.setSharpness(password, option);
      await onSettingChanged();
    } catch (error, stackTrace) {
      AppLogger.error('Error setting sharpness', error, stackTrace);
    }
  }

  Future<void> _setIsoLimit(IsoLimit option) async {
    try {
      await GoProApiService.setIsoLimit(password, option);
      await onSettingChanged();
    } catch (error, stackTrace) {
      AppLogger.error('Error setting ISO limit', error, stackTrace);
    }
  }

  Future<void> _setExposureCompensation(ExposureCompensation option) async {
    try {
      await GoProApiService.setExposureCompensation(password, option);
      await onSettingChanged();
    } catch (error, stackTrace) {
      AppLogger.error('Error setting exposure compensation', error, stackTrace);
    }
  }

  Widget _buildWhiteBalanceSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('White Balance'),
        DropdownButton<WhiteBalance>(
          isExpanded: true,
          value: cameraState.status.whiteBalance,
          onChanged: cameraState.isCameraOn
              ? (value) {
                  if (value != null) {
                    _setWhiteBalance(value);
                  }
                }
              : null,
          items: WhiteBalance.all
              .map(
                (wb) => DropdownMenuItem(
                  value: wb,
                  child: Row(
                    spacing: 8.0,
                    children: [wb.icon, Text(wb.getLocalizedName(context))],
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildSharpnessSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Sharpness'),
        DropdownButton<Sharpness>(
          isExpanded: true,
          value: cameraState.status.sharpness,
          onChanged: cameraState.isCameraOn
              ? (value) {
                  if (value != null) {
                    _setSharpness(value);
                  }
                }
              : null,
          items: Sharpness.all
              .map(
                (sharpness) => DropdownMenuItem(
                  value: sharpness,
                  child: Text(sharpness.getLocalizedName(context)),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildIsoSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('ISO Limit'),
        DropdownButton<IsoLimit>(
          isExpanded: true,
          value: cameraState.status.iso,
          onChanged: cameraState.isCameraOn
              ? (value) {
                  if (value != null) {
                    _setIsoLimit(value);
                  }
                }
              : null,
          items: IsoLimit.all
              .map(
                (iso) => DropdownMenuItem(
                  value: iso,
                  child: Text(iso.getLocalizedName(context)),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildExposureSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Exposure Compensation'),
        DropdownButton<ExposureCompensation>(
          isExpanded: true,
          value: cameraState.status.exposureCompensation,
          onChanged: cameraState.isCameraOn
              ? (value) {
                  if (value != null) {
                    _setExposureCompensation(value);
                  }
                }
              : null,
          items: ExposureCompensation.all
              .map(
                (ec) => DropdownMenuItem(
                  value: ec,
                  child: Text(ec.getLocalizedName(context)),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'ProTune Settings',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const Divider(),
            if (!isLandscape)
              // Landscape: 2-column layout
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // White Balance and Sharpness row
                  Row(
                    children: [
                      Expanded(child: _buildWhiteBalanceSelector(context)),
                      const SizedBox(width: 8),
                      Expanded(child: _buildSharpnessSelector(context)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // ISO and Exposure Compensation row
                  Row(
                    children: [
                      Expanded(child: _buildIsoSelector(context)),
                      const SizedBox(width: 8),
                      Expanded(child: _buildExposureSelector(context)),
                    ],
                  ),
                ],
              )
            else
              // Portrait: Single column layout
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildWhiteBalanceSelector(context),
                  const SizedBox(height: 12),
                  _buildSharpnessSelector(context),
                  const SizedBox(height: 12),
                  _buildIsoSelector(context),
                  const SizedBox(height: 12),
                  _buildExposureSelector(context),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
