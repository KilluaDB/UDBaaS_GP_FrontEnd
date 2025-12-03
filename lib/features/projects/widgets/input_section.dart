import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/core/constants/app_images.dart';
import 'package:dbaas_project/core/provider/settings_provider.dart';
import 'package:dbaas_project/core/util/validator.dart';
import 'package:dbaas_project/core/widgets/custome_text_form_field.dart';
import 'package:dbaas_project/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class InputSection extends StatefulWidget {
    final ValueChanged<bool>? onFormChanged;
     const InputSection({Key? key, this.onFormChanged}) : super(key: key);
  @override
  State<InputSection> createState() => _InputSectionState();
}

class _InputSectionState extends State<InputSection> {
  List<String> dataBase = ["SQL", "NoSQL"];
  List<String> cloudProviders = ["AWS", "Firebase", "Supabase", "Mongo Atlas"];

  String? selectedDatabase;
  String? selectedCloudProvider;
  late TextEditingController projectNameController;
    @override
  void initState() {
    super.initState();
    projectNameController = TextEditingController();
  }

  @override
  void dispose() {
    projectNameController.dispose();
    super.dispose();
  }
void notifyParent() {
  if (widget.onFormChanged != null) {
    widget.onFormChanged!(isFormValid);
  }
}

  bool get isFormValid {
    return projectNameController.text.isNotEmpty &&
        selectedDatabase != null &&
        selectedCloudProvider != null;
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final AppLocalizations local = AppLocalizations.of(context)!;
    SettingsProvider provider = Provider.of<SettingsProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
   
        SizedBox(height: 24.h),
        Text(
          local.projectName,
          style: textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.h),

        CustomTextFormField(
     controller: projectNameController,
 validator: (value) => Validator.validateProjectName(value),
 onChanged: (v) {
  setState(() {});
  notifyParent();
},
          hintText: 'E-commerce Platform',
          prefixIconName: AppImages.projectSelected,
        ),


        SizedBox(height: 24.h),
        Text(
          local.databaseType,
          style: textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.h),

        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            color: provider.isDark
                ? AppTheme.black
                : AppTheme.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: provider.isDark
                  ? AppTheme.white.withOpacity(0.2)
                  : AppTheme.black.withOpacity(0.2),
            ),
          ),
          child: DropdownButton<String>(
            isExpanded: true,
            underline: SizedBox(),
            iconEnabledColor: provider.isDark ? AppTheme.white : AppTheme.black,

            value: selectedDatabase,

            hint: Text(
              "Select database type",
              style: textTheme.titleMedium!.copyWith(
                color: provider.isDark ? AppTheme.white : AppTheme.black,
              ),
            ),

            dropdownColor: provider.isDark ? AppTheme.black : AppTheme.white,

            items: dataBase
                .map(
                  (db) => DropdownMenuItem(
                    value: db,
                    child: Text(
                      db,
                      style: textTheme.titleMedium!.copyWith(
                        color: provider.isDark
                            ? AppTheme.white
                            : AppTheme.black,
                      ),
                    ),
                  ),
                )
                .toList(),

            onChanged: (value) {
              setState(() {
                selectedDatabase = value;
              });
                notifyParent();
            },
          ),
        ),

 
        SizedBox(height: 24.h),
        Text(
          local.cloudProvider,
          style: textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.h),

        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            color: provider.isDark
                ? AppTheme.black
                : AppTheme.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: provider.isDark
                  ? AppTheme.white.withOpacity(0.2)
                  : AppTheme.black.withOpacity(0.2),
            ),
          ),
          child: DropdownButton<String>(
            isExpanded: true,
            underline: SizedBox(),
            iconEnabledColor: provider.isDark ? AppTheme.white : AppTheme.black,

            value: selectedCloudProvider,

            hint: Text(
              "Select Cloud Provider",
              style: textTheme.titleMedium!.copyWith(
                color: provider.isDark ? AppTheme.white : AppTheme.black,
              ),
            ),

            dropdownColor: provider.isDark ? AppTheme.black : AppTheme.white,

            items: cloudProviders
                .map(
                  (cp) => DropdownMenuItem(
                    value: cp,
                    child: Text(
                      cp,
                      style: textTheme.titleMedium!.copyWith(
                        color: provider.isDark
                            ? AppTheme.white
                            : AppTheme.black,
                      ),
                    ),
                  ),
                )
                .toList(),

            onChanged: (value) {
              setState(() {
                selectedCloudProvider = value;
              });
                notifyParent();
            },
          ),
        ),
      ],
    );
  }
}
