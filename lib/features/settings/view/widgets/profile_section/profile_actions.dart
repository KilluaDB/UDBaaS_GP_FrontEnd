import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class ProfileActions extends StatelessWidget {
  final VoidCallback onSave;

  const ProfileActions({super.key, required this.onSave});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final local = AppLocalizations.of(context)!;

    return ElevatedButton.icon(
      onPressed: onSave,
      icon: const Icon(Icons.save_outlined, color: AppTheme.white),
      label: Text(
        local.saveProfile,
        style: textTheme.titleMedium!.copyWith(color: AppTheme.white),
      ),
    );
  }
}
