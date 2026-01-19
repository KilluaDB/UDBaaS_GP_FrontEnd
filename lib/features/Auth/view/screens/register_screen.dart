import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/core/constants/app_images.dart';
import 'package:dbaas_project/features/settings/viewModel/user_provider.dart';
import 'package:dbaas_project/features/Auth/view/widgets/auth_section.dart';
import 'package:dbaas_project/features/Auth/view_model/auth_view_model.dart';
import 'package:dbaas_project/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = '/register';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isSignIn = true;
  bool isSignUp = false;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    AppLocalizations local = AppLocalizations.of(context)!;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  AppImages.appIcon,
                  fit: BoxFit.contain,
                  width: 120.w,
                  height: 120.h,
                ),
                SizedBox(height: 16.h),
                Text(
                  local.aiDbHub,
                  style: textTheme.headlineLarge?.copyWith(fontSize: 28.sp),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.h),
                Text(
                  local.yourIntelligentDatabaseManagementSolution,
                  style: textTheme.titleMedium?.copyWith(fontSize: 16.sp),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32.h),

                Container(
                  width: screenWidth * (557 / screenWidth).w,
                  height: (642).h,
                  padding: EdgeInsets.symmetric(
                    horizontal: 34.w,
                    vertical: 34.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.white,
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10.r,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Tabs
                      Container(
                        decoration: BoxDecoration(
                          color: AppTheme.semiGray,
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        child: Row(
                          children: [
                            buildTab(local.signIn, isSignIn, () {
                              setState(() {
                                isSignIn = true;
                                isSignUp = false;
                              });
                            }),
                            buildTab(local.signUp, isSignUp, () {
                              setState(() {
                                isSignUp = true;
                                isSignIn = false;
                              });
                            }),
                          ],
                        ),
                      ),
                      SizedBox(height: 24.h),

                      // Auth Section
                      BlocProvider(
                        create: (_) => AuthViewModel(
                          userProvider: context.read<UserProvider>(),
                        ),
                        child: AuthSection(
                          isSignUp: isSignUp,
                          onTap: switchAuthentication,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTab(String title, bool isSelected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
          padding: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppTheme.primary : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void switchAuthentication() {
    setState(() {
      isSignIn = !isSignIn;
      isSignUp = !isSignUp;
    });
  }
}
