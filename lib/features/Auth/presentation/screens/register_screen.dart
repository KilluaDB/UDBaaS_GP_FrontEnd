import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/core/constants/app_images.dart';
import 'package:dbaas_project/features/Auth/presentation/screens/widgets/auth_section.dart';
import 'package:flutter/material.dart';
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

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              SvgPicture.asset(AppImages.appIcon, fit: BoxFit.fill),
              Text('AI-DB Hub', style: textTheme.headlineLarge),
              Text(
                'Your intelligent database management solution',
                style: textTheme.titleMedium,
              ),
              SizedBox(height: 32.h),

              Container(
                width: 421.w,
                height: 642.h,
                padding: EdgeInsets.symmetric(horizontal: 34.w, vertical: 34.h),
                decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10.r,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.semiGray,
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                isSignIn = true;
                                isSignUp = false;
                                setState(() {});
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: 4.w,
                                  vertical: 4.h,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: isSignIn
                                      ? Colors.white
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                ),

                                child: Text(
                                  "Sign In",
                                  style: isSignIn
                                      ? textTheme.titleMedium!.copyWith(
                                          color: AppTheme.primary,
                                          fontWeight: FontWeight.bold,
                                        )
                                      : null,
                                ),
                              ),
                            ),
                          ),
                        
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                isSignUp = true;
                                isSignIn = false;
                                setState(() {});
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: 4.w,
                                 vertical: 4.h,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: isSignUp
                                      ? Colors.white
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  "Sign Up",
                                  style: isSignUp
                                      ? textTheme.titleMedium!.copyWith(
                                          color: AppTheme.primary,
                                          fontWeight: FontWeight.bold,
                                        )
                                      : null,
                                ),
                              ),
                            ),
                          ),
                        
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),
                    AuthSection(
                      isSignUp: isSignUp,
                      onTap: switchAuthentication,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void switchAuthentication() {
    isSignIn = !isSignIn;
    isSignUp = !isSignUp;
    setState(() {});
  }
}
