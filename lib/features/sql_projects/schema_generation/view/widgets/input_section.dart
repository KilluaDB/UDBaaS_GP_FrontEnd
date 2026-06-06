import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/core/widgets/custome_elevated_button.dart';
import 'package:dbaas_project/features/projects/data/models/project_model.dart';
import 'package:dbaas_project/features/sql_projects/schema_generation/view_model/geneartion_states.dart';
import 'package:dbaas_project/features/sql_projects/schema_generation/view_model/generation_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:dbaas_project/features/settings/viewModel/settings_provider.dart';

class InputSection extends StatefulWidget {
  final ProjectModel project;

  const InputSection({super.key, required this.project});

  @override
  State<InputSection> createState() => _InputSectionState();
}

class _InputSectionState extends State<InputSection> {
  late TextEditingController _promptController;

  @override
  void initState() {
    super.initState();
    _promptController = TextEditingController();
  }

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  void _generateSchema() {
    final text = _promptController.text.trim();
    if (text.isEmpty) return;

    context.read<SchemaGenerationCubit>().generateSchema(
          projectId: widget.project.id!,
          requirementText: text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final settings = Provider.of<SettingsProvider>(context);

    return BlocBuilder<SchemaGenerationCubit, SchemaGenerationStates>(
      builder: (context, state) {
        final isLoading = state is GenerateSchemaLoading;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: settings.isDark ? AppTheme.black : AppTheme.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppTheme.boldGray.withValues(alpha: 0.15),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          
              Row(
                children: [
                  Icon(Icons.psychology_alt_outlined,
                      color: AppTheme.primary, size: 20),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      "Schema Requirements",
                      style: textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: settings.isDark
                            ? AppTheme.white
                            : AppTheme.black,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 8.h),

              Text(
                "Describe your system and AI will generate a full database schema (ERD + SQL + Indexes).",
                style: textTheme.titleSmall!.copyWith(
                  color:
                      settings.isDark ? Colors.white70 : Colors.black54,
                ),
              ),

              SizedBox(height: 16.h),

              Container(
                height: 200.h,
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                decoration: BoxDecoration(
                  color: settings.isDark
                      ? Colors.grey[900]
                      : Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.boldGray.withValues(alpha: 0.15),
                  ),
                ),
                child: TextField(
                  controller: _promptController,
                  maxLines: null,
                  expands: true,
                  keyboardType: TextInputType.multiline,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: settings.isDark
                        ? AppTheme.white
                        : AppTheme.black,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText:
                        "Example:\nUniversity system with Students, Courses, Enrollments...\nMany-to-many + inheritance + constraints...",
                  ),
                ),
              ),

              SizedBox(height: 14.h),

            
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline,
                        size: 16, color: AppTheme.primary),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        "AI generates ERD diagram, SQL DDL, indexes & optimization report.",
                        style: textTheme.bodySmall!.copyWith(
                          color: settings.isDark
                              ? Colors.white70
                              : Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16.h),

            
              SizedBox(
                width: double.infinity,
                child: CustomElevatedButton(
                  onTap: isLoading ? null : _generateSchema,
                  child: isLoading
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.auto_fix_high,
                                size: 16, color: Colors.white),
                            SizedBox(width: 6.w),
                            Text(
                              "Generate Schema",
                              style: textTheme.titleSmall!.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}