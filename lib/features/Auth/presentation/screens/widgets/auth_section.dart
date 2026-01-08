import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/core/constants/app_images.dart';
import 'package:dbaas_project/core/widgets/custome_elevated_button.dart';
import 'package:dbaas_project/core/widgets/custome_text_form_field.dart';
import 'package:dbaas_project/features/home/home_screen.dart';
import 'package:dbaas_project/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthSection extends StatelessWidget {
  bool isSignUp;
  VoidCallback onTap;
  AuthSection({required this.isSignUp, required this.onTap});
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
      AppLocalizations local = AppLocalizations.of(context)!;
    TextTheme textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(local.emailAddress, style: textTheme.titleSmall),
        SizedBox(height: 8.h),
        CustomTextFormField(
          hintText: 'Enter your email',
          prefixIconName: AppImages.emailIcon,
        ),
        SizedBox(height: 20.h),
        Text(local.password, style: textTheme.titleSmall),
        SizedBox(height: 8.h),
        CustomTextFormField(
          hintText: 'Enter your password',
          isPassword: true,
          prefixIconName: AppImages.passwordIcon
        ),
   SizedBox(height: 20.h),
        isSignUp == false
            ? Text(
                local.forgetPassword,
                style: textTheme.titleSmall!.copyWith(color: AppTheme.primary),
              )
            : SizedBox(),
    SizedBox(height: 20.h),
        CustomElevatedButton(
          onTap: (){
                                Navigator.pushReplacementNamed(context,HomeScreen.routeName);
          },
          child: Text(
            isSignUp ? local.createAccount : local.signIn ,
            style: textTheme.titleSmall!.copyWith(color: AppTheme.white),
          ),
        ),
        SizedBox(height: 24.h),
        Divider(indent: 1, endIndent: 3),
        SizedBox(height: 24.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isSignUp ? local.alreadyHaveAccount : local.dontHaveAccount,
              style: textTheme.titleSmall,
            ),
            InkWell(
              onTap: onTap,
              child: Text(
                isSignUp ?local.signIn:local.signUp,
                style: textTheme.titleSmall!.copyWith(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
