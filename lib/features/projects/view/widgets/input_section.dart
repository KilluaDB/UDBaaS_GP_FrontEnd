import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/core/constants/app_images.dart';
import 'package:dbaas_project/core/util/ui_utils.dart';
import 'package:dbaas_project/core/util/validator.dart';
import 'package:dbaas_project/core/widgets/custome_elevated_button.dart';
import 'package:dbaas_project/core/widgets/custome_text_form_field.dart';
import 'package:dbaas_project/features/projects/view_model/project_cubit.dart';
import 'package:dbaas_project/features/projects/view_model/project_states.dart';
import 'package:dbaas_project/features/settings/viewModel/settings_provider.dart';
import 'package:dbaas_project/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class InputSection extends StatefulWidget {
  final ValueChanged<bool>? onFormChanged;
  const InputSection({Key? key, this.onFormChanged}) : super(key: key);

  @override
  State<InputSection> createState() => _InputSectionState();
}

class _InputSectionState extends State<InputSection> {
  final List<String> dataBase = ["SQL", "NoSQL"];
  final List<String> cloudProviders = [
    "AWS",
    "Firebase",
    "Supabase",
    "Mongo Atlas"
  ];

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

  bool get isFormValid {
    return projectNameController.text.isNotEmpty &&
        selectedDatabase != null &&
        selectedCloudProvider != null;
  }

  void notifyParent() {
    widget.onFormChanged?.call(isFormValid);
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final AppLocalizations local = AppLocalizations.of(context)!;
    final settingsProvider = context.watch<SettingsProvider>();

    return BlocConsumer<ProjectCubit, ProjectStates>(
      listener: (context, state) {
        if (state is CreateProjectLoading) {
          UiUtils.showLoading(context);
        } else {
          UiUtils.hideLoading();
        }

        if (state is CreateProjectSuccess) {
          UiUtils.showSuccessMessage(context,"Project created successfully");
          context.read<ProjectCubit>().getAllProject();
          Navigator.pop(context);
        }

        if (state is CreateProjectError) {
          UiUtils.showErrorMessage(context,state.message);
        }
      },
      builder: (context, state) {
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
              validator: Validator.validateProjectName,
              onChanged: (_) {
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
            _buildDropdown(
              context,
              value: selectedDatabase,
              hint: "Select database type",
              items: dataBase,
              onChanged: (value) {
                setState(() => selectedDatabase = value);
                notifyParent();
              },
              settingsProvider: settingsProvider,
              textTheme: textTheme,
            ),

            SizedBox(height: 24.h),

            Text(
              local.cloudProvider,
              style: textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            _buildDropdown(
              context,
              value: selectedCloudProvider,
              hint: "Select Cloud Provider",
              items: cloudProviders,
              onChanged: (value) {
                setState(() => selectedCloudProvider = value);
                notifyParent();
              },
              settingsProvider: settingsProvider,
              textTheme: textTheme,
            ),

            SizedBox(height: 24.h),

     
            Row(
              children: [
                Expanded(
                  child: CustomElevatedButton(
                    child: Text(local.cancel),
                    onTap: () => Navigator.pop(context),
                    backgroundColor: settingsProvider.isDark
                        ? AppTheme.black
                        : AppTheme.white,
                    foregroundColor: settingsProvider.isDark
                        ? AppTheme.white
                        : AppTheme.black,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: CustomElevatedButton(
                    child: Text(local.createNewProject),
          onTap: isFormValid
      ? () {
          final name = projectNameController.text.trim();
          final db = selectedDatabase!;
       

          context.read<ProjectCubit>().createProject(name, db);
        }
      : (){},
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildDropdown(
    BuildContext context, {
    required String? value,
    required String hint,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required SettingsProvider settingsProvider,
    required TextTheme textTheme,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: settingsProvider.isDark
            ? AppTheme.black
            : AppTheme.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: settingsProvider.isDark
              ? AppTheme.white.withOpacity(0.2)
              : AppTheme.black.withOpacity(0.2),
        ),
      ),
      child: DropdownButton<String>(
        isExpanded: true,
        underline: const SizedBox(),
        value: value,
        hint: Text(hint, style: textTheme.titleMedium),
        dropdownColor:
            settingsProvider.isDark ? AppTheme.black : AppTheme.white,
        items: items
            .map(
              (item) => DropdownMenuItem(
                value: item,
                child: Text(item, style: textTheme.titleMedium),
              ),
            )
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
