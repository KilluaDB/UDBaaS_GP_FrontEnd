import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/core/constants/app_images.dart';
import 'package:dbaas_project/core/provider/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class ProfileSection extends StatelessWidget {
  const ProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SettingsProvider>(context);
    final textTheme = Theme.of(context).textTheme;

    final nameController = TextEditingController(text: 'Aya');
    final emailController =
        TextEditingController(text: 'ayahame99@gmail.com');

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile = constraints.maxWidth < 700;

        return Container(
          width: double.infinity,
          padding:
              EdgeInsets.symmetric(horizontal: 0.04.sw, vertical: 0.03.sh),
          margin:
              EdgeInsets.symmetric(horizontal: 0.04.sw, vertical: 0.03.sh),
          decoration: BoxDecoration(
            color:  provider.isDark
                  ? AppTheme.black.withOpacity(0.1)
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
                      color: provider.isDark
                          ? AppTheme.white
                          : AppTheme.black,
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

              isMobile
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _avatarContent(
                          textTheme, emailController),
                    )
                  : Row(
                      children: _avatarContent(
                          textTheme, emailController),
                    ),

              SizedBox(height: 24.h),

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

              Align(
                alignment: Alignment.centerLeft,
                child: IntrinsicWidth(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 12.h),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.save_outlined,
                            color: AppTheme.white, size: 18),
                        SizedBox(width: 8.w),
                        Text(
                          'Save Profile',
                          style: textTheme.titleMedium!
                              .copyWith(color: AppTheme.white),
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


  List<Widget> _avatarContent(
      TextTheme textTheme, TextEditingController emailController) {
    return [
      CircleAvatar(
        radius: 80.r,
        backgroundColor: AppTheme.primary,
        child: Text(
          emailController.text
              .substring(0, emailController.text.indexOf('@')),
          style:
              textTheme.titleMedium!.copyWith(color: AppTheme.white),
        ),
      ),
      SizedBox(width: 16.w, height: 16.h),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton.icon(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(side: BorderSide(color: AppTheme.boldGray,width: 1.w),borderRadius: BorderRadius.circular(8))
            ),
            icon:
                const Icon(Icons.upload_file, color: AppTheme.black),
            label: Text(
              'Change Avatar',
              style: textTheme.titleMedium!
                  .copyWith(color: AppTheme.black),
            ),
          ),
          SizedBox(height: 8.h),
          Text('JPG, PNG up to 2MB',
              style: textTheme.bodySmall),
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
