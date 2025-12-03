import 'package:dbaas_project/features/settings/widgets/appearance_section.dart';
import 'package:dbaas_project/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsTab extends StatelessWidget {
  static const String routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    AppLocalizations local = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 160),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(local.settings, style: textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold)),

          SizedBox(height: 4.h),
          Text(local.manageAccountPreferences, style: textTheme.titleMedium),
          SizedBox(height: 24.h),
          AppearanceSection(),
        ],
      ),
    );
  }
}
