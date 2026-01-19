import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/core/constants/app_images.dart';
import 'package:dbaas_project/core/util/ui_utils.dart';
import 'package:dbaas_project/core/util/validator.dart';

import 'package:dbaas_project/core/widgets/custome_elevated_button.dart';
import 'package:dbaas_project/core/widgets/custome_text_form_field.dart';

import 'package:dbaas_project/features/Auth/view_model/auth_states.dart';
import 'package:dbaas_project/features/Auth/view_model/auth_view_model.dart';

import 'package:dbaas_project/features/home/presentation/screens/home_screen.dart';
import 'package:dbaas_project/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthSection extends StatefulWidget {
  final bool isSignUp;
  final VoidCallback onTap;
  const AuthSection({super.key, required this.isSignUp, required this.onTap});

  @override
  State<AuthSection> createState() => _AuthSectionState();
}

class _AuthSectionState extends State<AuthSection> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late GlobalKey<FormState> formKey;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations local = AppLocalizations.of(context)!;
    TextTheme textTheme = Theme.of(context).textTheme;
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(local.emailAddress, style: textTheme.titleSmall),
          SizedBox(height: 8.h),
          CustomTextFormField(
            controller: emailController,
            validator: (value) {
              return Validator.validateEmail(value);
            },
            hintText: 'Enter your email',
            prefixIconName: AppImages.emailIcon,
          ),
          SizedBox(height: 20.h),
          Text(local.password, style: textTheme.titleSmall),
          SizedBox(height: 8.h),
          CustomTextFormField(
            controller: passwordController,
            validator: (value) {
              return Validator.validatePassword(value);
            },
            hintText: 'Enter your password',
            isPassword: true,
            prefixIconName: AppImages.passwordIcon,
          ),

          SizedBox(height: 20.h),
          widget.isSignUp == false
              ? BlocListener<AuthViewModel, AuthState>(
                  listener: (context, state) {
                    if (state is LoginLoading) {
                      UiUtils.showLoading(context);
                    } else if (state is LoginSuccess) {
                      UiUtils.hideLoading(context);
                      UiUtils.showSuccessMessage("Successfull Login !");
                      Navigator.of(
                        context,
                      ).pushReplacementNamed(HomeScreen.routeName);
                    } else if (state is LoginError) {
                      UiUtils.hideLoading(context);
                      UiUtils.showErrorMessage(state.message);
                    }
                  },
                  child: CustomElevatedButton(
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        context.read<AuthViewModel>().login(
                          emailController.text,
                          passwordController.text,
                        );
                      }
                    },
                    child: Text(
                      local.signIn,
                      style: textTheme.titleSmall!.copyWith(
                        color: AppTheme.white,
                      ),
                    ),
                  ),
                )
              : BlocListener<AuthViewModel, AuthState>(
                  listener: (context, state) {
                    if (state is RegisterLoading) {
                      UiUtils.showLoading(context);
                    } else if (state is RegisterSuccess) {
                      UiUtils.hideLoading(context);
                      UiUtils.showSuccessMessage(
                        state.registerResponse.message!,
                      );
                      Navigator.of(
                        context,
                      ).pushReplacementNamed(HomeScreen.routeName);
                    } else if (state is RegisterError) {
                      UiUtils.hideLoading(context);
                      UiUtils.showErrorMessage(state.message);
                    }
                  },
                  child: CustomElevatedButton(
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        context.read<AuthViewModel>().register(
                          emailController.text,
                          passwordController.text,
                        );
                      }
                    },
                    child: Text(
                      local.createAccount,
                      style: textTheme.titleSmall!.copyWith(
                        color: AppTheme.white,
                      ),
                    ),
                  ),
                ),

          SizedBox(height: 24.h),
          Divider(indent: 1, endIndent: 3),
          SizedBox(height: 24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.isSignUp
                    ? local.alreadyHaveAccount
                    : local.dontHaveAccount,
                style: textTheme.titleSmall,
                softWrap: true,
              ),
              InkWell(
                onTap: widget.onTap,
                child: Text(
                  softWrap: true,
                  widget.isSignUp ? local.signIn : local.signUp,
                  style: textTheme.titleSmall!.copyWith(
                    color: AppTheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
