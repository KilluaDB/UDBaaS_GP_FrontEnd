import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/features/settings/viewModel/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class CustomTextFormField extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final String ?prefixIconName;
  final String? Function(String?)? validator;
  final void Function(String)? onSubmitted;

  final bool isPassword;
   CustomTextFormField({
    super.key,
    required this.hintText,
     this.prefixIconName,
    this.isPassword = false,
    this.controller,
    this.onChanged,
    this.validator,
    this.onSubmitted,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool isObscure = widget.isPassword;
  
  @override
  Widget build(BuildContext context) {
      final settingsProvider = context.watch<SettingsProvider>();

    return TextFormField(
      
      controller: widget.controller,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onSubmitted,
      style: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 16.sp,
        color:settingsProvider.isDark? AppTheme.white:AppTheme.gray,
      ),
      decoration: widget.prefixIconName!=null?InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
          child: SvgPicture.asset(
            widget.prefixIconName!,
            width: 20.w,
            height: 20.h,
          ),
        ),

        hintText: widget.hintText,
      ):null,
      cursorColor: AppTheme.white,
      validator: widget.validator,
      obscureText: isObscure,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
    );
  }
}
