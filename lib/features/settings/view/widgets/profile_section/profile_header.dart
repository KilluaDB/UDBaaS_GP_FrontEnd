import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/core/constants/app_images.dart';
import 'package:dbaas_project/features/settings/viewModel/settings_provider.dart';
import 'package:dbaas_project/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({super.key});

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final provider = context.watch<SettingsProvider>();
    final local = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.asset(AppImages.profileLogo, width: 20, height: 20),
            const SizedBox(width: 6),
            Text(
              local.profileSettings,
              style: textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: provider.isDark ? AppTheme.white : AppTheme.black,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(local.updateInforamtions, style: textTheme.titleMedium),
      ],
    );
  }
}
