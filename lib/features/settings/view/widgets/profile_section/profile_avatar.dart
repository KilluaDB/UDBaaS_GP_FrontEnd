import 'dart:io';
import 'dart:typed_data';
import 'package:dbaas_project/core/helper/pick_image.dart';
import 'package:dbaas_project/core/helper/save_avatar.dart';
import 'package:dbaas_project/features/settings/viewModel/user_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/features/settings/viewModel/settings_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      context.read<SettingsProvider>().loadSavedAvatar();
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
        settingsProvider.webAvatarBytes != null
            ? Image.memory(settingsProvider.webAvatarBytes!, fit: BoxFit.cover)
            : _initials(userProvider.displayName, textTheme),
      );
    } else {
      avatarWidget = _buildAvatar(
        settingsProvider.avatarFile != null
            ? Image.file(settingsProvider.avatarFile!, fit: BoxFit.cover)
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

                  context.read<SettingsProvider>().updateAvatar(
                    file: result.file,
                    bytes: result.bytes,
                  );

                  await SaveAvatar.saveAvatar(
                    file: result.file,
                    bytes: result.bytes,
                  );
                },
                icon: const Icon(Icons.upload_file, color: AppTheme.black),
                label: Text(
                  'Change Avatar',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: settingsProvider.isDark
                        ? AppTheme.white
                        : AppTheme.black,
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
