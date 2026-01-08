import 'dart:io';
import 'dart:typed_data';
import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/core/constants/app_images.dart';
import 'package:dbaas_project/core/provider/settings_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileSection extends StatefulWidget {
  const ProfileSection({super.key});

  @override
  State<ProfileSection> createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<ProfileSection> {
  late final TextEditingController nameController;
  late final TextEditingController emailController;

  final ImagePicker _picker = ImagePicker();
  Uint8List? webAvatarBytes; // فقط للويب

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: 'Aya');
    emailController = TextEditingController(text: 'ayahame99@gmail.com');
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(BuildContext context) async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null) {
      if (kIsWeb) {
        webAvatarBytes = await image.readAsBytes();
      } else {
        final file = File(image.path);
        context.read<SettingsProvider>().setAvatar(file);
      }
      setState(() {});
    }
  }

  late SettingsProvider provider;
  @override
  Widget build(BuildContext context) {
    provider = Provider.of<SettingsProvider>(context);
    final textTheme = Theme.of(context).textTheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile = constraints.maxWidth < 700;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 0.04.sw, vertical: 0.03.sh),
          margin: EdgeInsets.symmetric(horizontal: 0.04.sw, vertical: 0.03.sh),
          decoration: BoxDecoration(
            color: provider.isDark
                ? AppTheme.black.withOpacity(0.05)
                : AppTheme.white,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: provider.isDark
                  ? AppTheme.white
                  : AppTheme.black.withOpacity(0.1),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              Row(
                children: [
                  SvgPicture.asset(
                    AppImages.profileLogo,
                    width: 20.w,
                    height: 20.h,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    'Profile Settings',
                    style: textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: provider.isDark ? AppTheme.white : AppTheme.black,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4.h),
              Text(
                "Update your personal information and profile details",
                style: textTheme.titleMedium,
              ),

              SizedBox(height: 24.h),

              /// Avatar Section
              isMobile
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _avatarContent(textTheme, provider),
                    )
                  : Row(children: _avatarContent(textTheme, provider)),

              SizedBox(height: 24.h),

              /// Input Fields
              isMobile
                  ? Column(
                      children: [
                        _inputField(
                          label: 'Full Name',
                          controller: nameController,
                          textTheme: textTheme,
                        ),
                        SizedBox(height: 16.h),
                        _inputField(
                          label: 'Email Address',
                          controller: emailController,
                          readOnly: true,
                          textTheme: textTheme,
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: _inputField(
                            label: 'Full Name',
                            controller: nameController,
                            textTheme: textTheme,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: _inputField(
                            label: 'Email Address',
                            controller: emailController,
                            readOnly: true,
                            textTheme: textTheme,
                          ),
                        ),
                      ],
                    ),

              SizedBox(height: 32.h),

              /// Save Profile Button صغير
              Align(
                alignment: Alignment.centerLeft,
                child: IntrinsicWidth(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 12.h,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.save_outlined,
                          color: AppTheme.white,
                          size: 18,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Save Profile',
                          style: textTheme.titleMedium!.copyWith(
                            color: AppTheme.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _avatarContent(TextTheme textTheme, SettingsProvider provider) {
    Widget avatarWidget;

    if (kIsWeb) {
      // Web: استخدم Image.memory
      avatarWidget = SizedBox(
        width: 160.r,
        height: 160.r,
        child: ClipOval(
          child: webAvatarBytes != null
              ? Image.memory(
                  webAvatarBytes!,
                  fit: BoxFit.cover,
                  width: 160.r,
                  height: 160.r,
                )
              : Container(
                  color: AppTheme.primary,
                  alignment: Alignment.center,
                  child: Text(
                    emailController.text.substring(
                      0,
                      emailController.text.indexOf('@'),
                    ),
                    style: textTheme.titleMedium!.copyWith(
                      color: AppTheme.white,
                    ),
                  ),
                ),
        ),
      );
    } else {
      // Mobile: استخدم Image.file
      avatarWidget = SizedBox(
        width: 160.r,
        height: 160.r,
        child: ClipOval(
          child: provider.avatarFile != null
              ? Image.file(
                  provider.avatarFile!,
                  fit: BoxFit.cover,
                  width: 160.r,
                  height: 160.r,
                )
              : Container(
                  color: AppTheme.primary,
                  alignment: Alignment.center,
                  child: Text(
                    emailController.text.substring(
                      0,
                      emailController.text.indexOf('@'),
                    ),
                    style: textTheme.titleMedium!.copyWith(
                      color: AppTheme.white,
                    ),
                  ),
                ),
        ),
      );
    }

    return [
      avatarWidget,
      SizedBox(width: 16.w, height: 16.h),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton.icon(
            onPressed: () => _pickImage(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: AppTheme.boldGray, width: 1.w),
                borderRadius: BorderRadius.circular(14.r),
              ),
            ),
            icon: const Icon(Icons.upload_file, color: AppTheme.black),
            label: Text(
              'Change Avatar',
              style: textTheme.titleMedium!.copyWith(color: AppTheme.black),
            ),
          ),
          SizedBox(height: 8.h),
          Text('JPG, PNG up to 2MB', style: textTheme.bodySmall),
        ],
      ),
    ];
  }

  Widget _inputField({
    required String label,
    required TextEditingController controller,
    required TextTheme textTheme,
    bool readOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: textTheme.titleMedium),
        SizedBox(height: 8.h),
        TextField(
          style: TextStyle(
            color: provider.isDark
                ? AppTheme.white
                : AppTheme.black.withOpacity(0.1),
          ),
          controller: controller,
          readOnly: readOnly,
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
