import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/core/util/ui_utils.dart';
import 'package:dbaas_project/features/projects/data/models/project_model.dart';
import 'package:dbaas_project/features/projects/view_model/project_cubit.dart';
import 'package:dbaas_project/features/projects/view_model/project_states.dart';
import 'package:dbaas_project/features/settings/viewModel/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class DeleteScreen extends StatelessWidget {
  static const String routeName = 'delete_project';
  final ProjectModel project;

  const DeleteScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final provider = Provider.of<SettingsProvider>(context);
    final isDark = provider.isDark;

    return BlocListener<ProjectCubit, ProjectStates>(
      listener: (context, state) {
        if (state is DeleteProjectLoading) {
          UiUtils.showLoading(context);
        } else if (state is DeleteProjectSuccess) {
          UiUtils.hideLoading();
          UiUtils.showSuccessMessage(context, "Project deleted successfully");
          Navigator.pop(context); 
        } else if (state is DeleteProjectError) {
          UiUtils.hideLoading();
          UiUtils.showErrorMessage(context, state.message);
        }
      },
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Delete Project',
              style: textTheme.headlineMedium!.copyWith(
                color: isDark ? AppTheme.white : AppTheme.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 24.h),

          
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: AppTheme.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppTheme.red.withOpacity(0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.warning_amber_rounded, color: AppTheme.red, size: 28.sp),
                  SizedBox(width: 12.w),
                  Expanded(
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
                        SizedBox(height: 4.h),
                        Text(
                          'Deleting this project is permanent and cannot be undone. All data, configurations, and settings will be lost forever.',
                          style: textTheme.bodySmall!.copyWith(
                            color: isDark ? AppTheme.white : AppTheme.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),

            // Project Details Card
            Container(
              padding: EdgeInsets.all(20.r),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.black : AppTheme.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Project Details',
                    style: textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20.h),
                  _buildDetailRow('Project Name', project.name ?? 'N/A', textTheme, isDark),
                  const Divider(),
                  _buildDetailRow('Database Type', project.dbType?.toUpperCase() ?? 'SQL', textTheme, isDark, isBadge: true),
                  const Divider(),
                  _buildDetailRow('Cloud Provider', 'AWS', textTheme, isDark),
                  
                  SizedBox(height: 24.h),
                  Text(
                    'What will be deleted:',
                    style: textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12.h),
                  _buildBulletPoint('All tables and data', textTheme),
                  _buildBulletPoint('Database configurations and schemas', textTheme),
                  _buildBulletPoint('All indexes and optimization settings', textTheme),
                  _buildBulletPoint('Backup and replication settings', textTheme),
                  _buildBulletPoint('Query history and saved queries', textTheme),

                  SizedBox(height: 32.h),

                  // Delete Button
                  SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: ElevatedButton.icon(
                      onPressed: () {
                      
                        context.read<ProjectCubit>().deleteProject(project.id!);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.red,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      icon: const Icon(Icons.delete_outline),
                      label: const Text(
                        'Delete Project Permanently',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildDetailRow(String label, String value, TextTheme textTheme, bool isDark, {bool isBadge = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: textTheme.bodyMedium!.copyWith(color: Colors.grey)),
          if (isBadge)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Text(value, style: textTheme.bodySmall!.copyWith(color: Colors.blue, fontWeight: FontWeight.bold)),
            )
          else
            Text(value, style: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text, TextTheme textTheme) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Icon(Icons.circle, size: 6.r, color: AppTheme.red),
          SizedBox(width: 10.w),
          Text(text, style: textTheme.bodySmall!.copyWith(color: Colors.grey[600])),
        ],
      ),
    );
  }
}