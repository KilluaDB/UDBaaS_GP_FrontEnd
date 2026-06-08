import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/core/constants/app_images.dart';
import 'package:dbaas_project/features/no_sql_projects/collections/view/widgets/create_colletion_sheet.dart';
import 'package:dbaas_project/features/no_sql_projects/collections/view_model/mongo_collections_cubit.dart';
import 'package:dbaas_project/features/settings/viewModel/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class EmptyCollectionScreen extends StatelessWidget {
  String projectId;
   EmptyCollectionScreen({required this.projectId});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final provider = Provider.of<SettingsProvider>(context);

    return Container(
      height: double.infinity,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(width: 1, color: AppTheme.boldGray),
        color: provider.isDark ? AppTheme.gray : AppTheme.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.grid_on_rounded, color: AppTheme.primary, size: 20.sp),
              SizedBox(width: 8.w),
              Text('Collections', style: textTheme.titleMedium),
            ],
          ),

          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Image.asset(
                    AppImages.emptyProjectsLogo,
                    width: 80.w,
                    height: 80.h,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'No Collections Available',
                    style: textTheme.titleSmall!.copyWith(
                      fontSize: 18.sp,
                      color: provider.isDark ? AppTheme.white : AppTheme.black,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Get started by creating your first Collection ',
                    textAlign: TextAlign.center,
                    style: textTheme.titleMedium!.copyWith(fontSize: 14.sp),
                  ),
                  SizedBox(height: 20.h),
                  Builder(
                    builder: (btnContext) {
                      return ElevatedButton(
                        onPressed: () {
 final cubit = context.read<MongoCollectionsCubit>();
  showCreateCollectionSheet(context, projectId, cubit);
                     },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add, size: 16.sp),
                            SizedBox(width: 8.w),
                            Text(
                              'Add Collection',
                              style: textTheme.titleSmall!.copyWith(
                                fontSize: 14.sp,
                                color: AppTheme.white,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
