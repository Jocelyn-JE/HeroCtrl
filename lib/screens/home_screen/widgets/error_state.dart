import 'package:flutter/material.dart';
import 'package:heroctrl/l10n/app_localizations.dart';

class ErrorState extends StatelessWidget {
  final String error;

  const ErrorState({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(child: Text(l10n.errorLabel(error)));
  }
}
