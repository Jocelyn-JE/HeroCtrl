import 'package:flutter/material.dart';
import 'package:heroctrl/gopro_settings/protune/color_profile.dart';
import 'package:heroctrl/gopro_settings/protune/pro_tune.dart';
import 'package:heroctrl/l10n/app_localizations.dart';
import 'package:heroctrl/services/gopro_api_service.dart';
import 'package:heroctrl/utils/logger.dart';
import 'package:heroctrl/utils/snackbar.dart';

class ProtuneSettingCard extends StatefulWidget {
  final String password;

  const ProtuneSettingCard({super.key, required this.password});

  @override
  State<ProtuneSettingCard> createState() => _ProtuneSettingCardState();
}

class _ProtuneSettingCardState extends State<ProtuneSettingCard> {
  bool? _isProtuneOn;
  ColorProfile? _colorProfile;
  bool _isLoading = true;
  bool _isExpandedColor = false;

  @override
  void initState() {
    super.initState();
    _fetchProtuneSetting();
    _fetchColorProfile();
  }

  Future<void> _fetchProtuneSetting() async {
    try {
      final protune = await GoProApiService.getProtune(widget.password);
      if (mounted) {
        setState(() {
          _isProtuneOn = protune == ProTune.on;
          _isLoading = false;
        });
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching ProTune setting', e, stackTrace);
      if (mounted) {
        setState(() => _isLoading = false);
        showSnackBarError(context, 'Error fetching ProTune setting: $e');
      }
    }
  }

  Future<void> _fetchColorProfile() async {
    try {
      final colorProfile = await GoProApiService.getColorProfile(
        widget.password,
      );
      if (mounted) {
        setState(() {
          _colorProfile = colorProfile;
        });
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching color profile', e, stackTrace);
    }
  }

  Future<void> _setProtune(bool enabled) async {
    final previous = _isProtuneOn;
    setState(() => _isProtuneOn = enabled);
    try {
      await GoProApiService.setProtune(
        widget.password,
        enabled ? ProTune.on : ProTune.off,
      );
    } catch (e, stackTrace) {
      AppLogger.error('Error setting ProTune', e, stackTrace);
      if (mounted) {
        setState(() => _isProtuneOn = previous);
        showSnackBarError(context, 'Error setting ProTune: $e');
      }
    }
  }

  Future<void> _setColorProfile(ColorProfile option) async {
    final previous = _colorProfile;
    setState(() => _colorProfile = option);
    try {
      await GoProApiService.setColorProfile(widget.password, option);
    } catch (e, stackTrace) {
      AppLogger.error('Error setting color profile', e, stackTrace);
      if (mounted) {
        setState(() => _colorProfile = previous);
        showSnackBarError(context, 'Error setting color profile: $e');
      }
    }
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.protuneSetting,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.protuneSettingSubtitle,
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
                      value: _isProtuneOn ?? false,
                      onChanged: _setProtune,
                    ),
                  ),
              ],
            ),
            // Expandable color profile section when ProTune is enabled
            if (_isProtuneOn == true)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () {
                      setState(() => _isExpandedColor = !_isExpandedColor);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Color Profile',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(fontWeight: FontWeight.w500),
                                ),
                                if (_colorProfile != null)
                                  Text(
                                    _colorProfile!.getLocalizedName(context),
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                              ],
                            ),
                          ),
                          Icon(
                            _isExpandedColor
                                ? Icons.expand_less
                                : Icons.expand_more,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_isExpandedColor)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: DropdownButton<ColorProfile>(
                        isExpanded: true,
                        value: _colorProfile,
                        onChanged: (value) {
                          if (value != null) {
                            _setColorProfile(value);
                          }
                        },
                        items: ColorProfile.all
                            .map(
                              (cp) => DropdownMenuItem(
                                value: cp,
                                child: Text(cp.getLocalizedName(context)),
                              ),
                            )
                            .toList(),
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
