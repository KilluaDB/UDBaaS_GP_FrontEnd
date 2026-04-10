import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/core/helper/pick_image.dart';
import 'package:dbaas_project/core/helper/save_avatar.dart';
import 'package:dbaas_project/core/util/ui_utils.dart';
import 'package:dbaas_project/features/settings/viewModel/settings_provider.dart';
import 'package:dbaas_project/features/settings/viewModel/user_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ProfileAvatar extends StatefulWidget {
  const ProfileAvatar({super.key});

  @override
  State<ProfileAvatar> createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<ProfileAvatar> {
  late SettingsProvider settingsProvider;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().loadAvatar();
    });
  }

  @override
  Widget build(BuildContext context) {
    settingsProvider = context.watch<SettingsProvider>();
    final userProvider = context.watch<UserProvider>();
    final textTheme = Theme.of(context).textTheme;

    Widget avatarWidget;

    if (kIsWeb) {
      avatarWidget = _buildAvatar(
        userProvider.webAvatarBytes != null
            ? Image.memory(userProvider.webAvatarBytes!, fit: BoxFit.cover)
            : _initials(userProvider.displayName, textTheme),
      );
    } else {
      avatarWidget = _buildAvatar(
        userProvider.avatarFile != null
            ? Image.file(userProvider.avatarFile!, fit: BoxFit.cover)
            : _initials(userProvider.displayName, textTheme),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        avatarWidget,
        SizedBox(width: 16.w),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton.icon(
                onPressed: () async {
                  final result = await PickImage.pickImage();
                  if (result == null) return;

                  context.read<UserProvider>().updateAvatar(
                    file: result.file,
                    bytes: result.bytes,
                  );

                  await SaveAvatar.saveAvatar(
                    file: result.file,
                    bytes: result.bytes,
                  );
                      UiUtils.showSuccessMessage(context,"Profile Photo is Updated");
                },
                icon: const Icon(Icons.upload_file, color: AppTheme.black),
                label: Text(
                  'Change Avatar',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: AppTheme.black
                     
                  ),
                ),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                'JPG, PNG up to 2MB',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: settingsProvider.isDark
                      ? AppTheme.white
                      : AppTheme.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar(Widget child) => SizedBox(
    width: 160.r,
    height: 160.r,
    child: ClipOval(child: child),
  );

  Widget _initials(String displayName, TextTheme textTheme) {
    return Container(
      color: AppTheme.primary,
      alignment: Alignment.center,
      child: Text(
        displayName,
        style: textTheme.titleMedium!.copyWith(color: AppTheme.white),
      ),
    );
  }
}
