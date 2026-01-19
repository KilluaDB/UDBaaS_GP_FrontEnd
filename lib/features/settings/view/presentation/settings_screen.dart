import 'package:dbaas_project/features/settings/view/widgets/appearance_section.dart';
import 'package:dbaas_project/features/settings/view/widgets/delete_section.dart';
import 'package:dbaas_project/features/settings/view/widgets/notification.dart';
import 'package:dbaas_project/features/settings/view/widgets/profile_section/profile_section.dart';
import 'package:dbaas_project/features/settings/viewModel/setting_cubit.dart';
import 'package:dbaas_project/features/settings/viewModel/user_provider.dart';
import 'package:dbaas_project/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsScreen extends StatelessWidget {
  static const String routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    AppLocalizations local = AppLocalizations.of(context)!;
    final userProvider = context.read<UserProvider>();
    return BlocProvider(
      create: (_) => SettingCubit(userProvider: userProvider),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 0.05.sw),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                local.settings,
                style: textTheme.headlineSmall!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 4.h),
              Text(
                local.manageAccountPreferences,
                style: textTheme.titleMedium,
              ),
              SizedBox(height: 24.h),
              ProfileSection(),
              AppearanceSection(),
              NotificationSection(),
              DeleteSection(),
            ],
          ),
        ),
      ),
    );
  }
}
