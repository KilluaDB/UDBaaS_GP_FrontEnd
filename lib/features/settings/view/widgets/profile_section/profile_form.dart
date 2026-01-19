// profile_form.dart
import 'package:dbaas_project/features/settings/viewModel/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/features/settings/viewModel/settings_provider.dart';

class ProfileForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;

  const ProfileForm({
    super.key,
    required this.nameController,
    required this.emailController,
  });

  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.watch<SettingsProvider>();
    final textTheme = Theme.of(context).textTheme;
    final userProvider = context.watch<UserProvider>();

    nameController.value = nameController.value.copyWith(
      text: userProvider.displayName,
      selection: TextSelection.fromPosition(
        TextPosition(offset: userProvider.displayName.length),
      ),
      composing: TextRange.empty,
    );

    return Row(
      children: [
        Expanded(
          child: _field(
            label: 'Full Name',
            controller: nameController,
            textTheme: textTheme,
            provider: settingsProvider,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: _field(
            label: 'Email Address',
            controller: emailController,
            textTheme: textTheme,
            provider: settingsProvider,
            readOnly: true,
          ),
        ),
      ],
    );
  }

  Widget _field({
    required String label,
    required TextEditingController controller,
    required TextTheme textTheme,
    required SettingsProvider provider,
    bool readOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.titleMedium!.copyWith(
            color: provider.isDark ? AppTheme.white : AppTheme.black,
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          readOnly: readOnly,
          style: textTheme.titleSmall!.copyWith(
            color: provider.isDark ? AppTheme.white : AppTheme.black,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppTheme.boldGray.withOpacity(0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
