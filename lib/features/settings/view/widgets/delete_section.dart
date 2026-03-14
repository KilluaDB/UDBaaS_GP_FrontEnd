import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/core/util/ui_utils.dart';
import 'package:dbaas_project/features/settings/viewModel/setting_cubit.dart';
import 'package:dbaas_project/features/settings/viewModel/settings_provider.dart';
import 'package:dbaas_project/features/Auth/view/screens/register_screen.dart';
import 'package:dbaas_project/features/settings/viewModel/settings_states.dart';
import 'package:dbaas_project/features/settings/viewModel/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class DeleteSection extends StatelessWidget {
  const DeleteSection({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    SettingsProvider provider = Provider.of<SettingsProvider>(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 0.04.sw, vertical: 0.03.sh),
      margin: EdgeInsets.symmetric(horizontal: 0.04.sw, vertical: 0.03.sh),
      decoration: BoxDecoration(
        color: provider.isDark
            ? AppTheme.black.withOpacity(0.1)
            : AppTheme.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppTheme.red),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Danger Zone',
            style: textTheme.titleMedium!.copyWith(
              color: AppTheme.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 7.h),
          Text(
            'Irreversible and destructive actions',
            style: textTheme.titleMedium,
          ),
          SizedBox(height: 24.h),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 0.02.sw,
              vertical: 0.02.sh,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: AppTheme.red),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Delete Account',
                        style: textTheme.titleMedium!.copyWith(
                          color: AppTheme.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 7.h),
                      Text(
                        'Permanently delete your account and all associated data',
                        style: textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 16.w),

                Expanded(
                  flex: 1,
                  child: BlocListener<SettingCubit, SettingsStates>(
                    listener: (context, state) {
                      if (state is DeleteLoading) {
                        UiUtils.showLoading(context);
                      } else if (state is DeleteSuccess) {
                        UiUtils.hideLoading();
                        UiUtils.showSuccessMessage(context,
                          "Account deleted successfully !",
                        );
                        Navigator.of(
                          context,
                        ).pushReplacementNamed(RegisterScreen.routeName);
                      } else if (state is DeleteError) {
                        UiUtils.hideLoading();
                        UiUtils.showErrorMessage(context,state.message);
                      }
                    },
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.red,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      onPressed: () {
                        final userId = context
                            .read<UserProvider>()
                            .currentUser
                            ?.data
                            ?.id;
                        if (userId != null) {
                          context.read<SettingCubit>().delete(userId);
                        } else {
                          UiUtils.showErrorMessage(context,"User ID not found");
                        }
                      },

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.delete_rounded, color: AppTheme.white),
                          SizedBox(width: 8.w),
                          Flexible(
                            child: Text(
                              'Delete Account',
                              style: textTheme.titleMedium!.copyWith(
                                color: AppTheme.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
               
               
               
                ),
            
            
              ],
            ),
          ),
          SizedBox(height: 17.h),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 0.02.sw,
              vertical: 0.02.sh,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: AppTheme.red),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Log out',
                        style: textTheme.titleMedium!.copyWith(
                          color: AppTheme.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 7.h),
                      Text(
                        'Sign out of your account safely',
                        style: textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 16.w),

                Expanded(
                  flex: 1,
                  child: BlocListener<SettingCubit, SettingsStates>(
                    listener: (context, state) {
                      if (state is LogoutLoading) {
                        UiUtils.showLoading(context);
                      } else if (state is LogoutSuccess) {
                        UiUtils.hideLoading();
                        UiUtils.showSuccessMessage(context,"Logged out successfully !");
                        Navigator.of(
                          context,
                        ).pushReplacementNamed(RegisterScreen.routeName);
                      } else if (state is LogoutError) {
                        UiUtils.hideLoading();
                        UiUtils.showErrorMessage(context,state.message);
                      }
                    },
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.red,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      onPressed: () {
                        context.read<SettingCubit>().logout();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout_outlined, color: AppTheme.white),
                          SizedBox(width: 8.w),
                          Flexible(
                            child: Text(
                              'Logout',
                              style: textTheme.titleMedium!.copyWith(
                                color: AppTheme.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
