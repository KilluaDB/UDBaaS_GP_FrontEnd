import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/core/util/ui_utils.dart';
import 'package:dbaas_project/features/settings/viewModel/settings_provider.dart';
import 'package:dbaas_project/features/settings/viewModel/user_provider.dart';
import 'package:dbaas_project/features/settings/view/widgets/profile_section/profile_actions.dart';
import 'package:dbaas_project/features/settings/view/widgets/profile_section/profile_avatar.dart';
import 'package:dbaas_project/features/settings/view/widgets/profile_section/profile_form.dart';
import 'package:dbaas_project/features/settings/view/widgets/profile_section/profile_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ProfileSection extends StatefulWidget {
  const ProfileSection({super.key});

  @override
  State<ProfileSection> createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<ProfileSection> {
  late TextEditingController nameController;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    final userProvider = context.read<UserProvider>();

    nameController = TextEditingController(text: userProvider.displayName);

    emailController = TextEditingController(
      text: userProvider.currentUser?.data?.email ?? 'Guest@gmail.com',
    );
  }
@override
void didChangeDependencies() {
  super.didChangeDependencies();
  final userProvider = context.watch<UserProvider>();
  

  if (nameController.text != userProvider.displayName) {
    nameController.text = userProvider.displayName;
  }
  
  String email = userProvider.currentUser?.data?.email ?? 'Guest@gmail.com';
  if (emailController.text != email) {
    emailController.text = email;
  }
}
  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.watch<SettingsProvider>();
    final userProvider = context.watch<UserProvider>();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 0.04.sw, vertical: 0.03.sh),
      margin: EdgeInsets.symmetric(horizontal: 0.04.sw, vertical: 0.03.sh),
      decoration: BoxDecoration(
        color: settingsProvider.isDark
            ? AppTheme.black.withOpacity(0.05)
            : AppTheme.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: settingsProvider.isDark
              ? AppTheme.white
              : AppTheme.black.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ProfileHeader(),
          SizedBox(height: 24.h),

          const ProfileAvatar(),
          SizedBox(height: 24.h),

          ProfileForm(
            nameController: nameController,
            emailController: emailController,
          ),

          SizedBox(height: 32.h),

          ProfileActions(
            onSave: () async {
              final newName = nameController.text.trim();

              if (newName.isEmpty || newName == userProvider.displayName)
                return;

              await userProvider.updateUserName(newName);
              UiUtils.showSuccessMessage(context,"User Name is Updated");
            },
          ),
        ],
      ),
    );
  }
}
