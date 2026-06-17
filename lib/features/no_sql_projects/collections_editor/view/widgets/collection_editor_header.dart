import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/features/settings/viewModel/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';


class CollectionEditorHeader extends StatelessWidget {
  final String collectionName;
  final int documentsCount;
  final VoidCallback onAddDoc;
  final VoidCallback onDeleteAll;
  final VoidCallback onUpdateDocs;

  const CollectionEditorHeader({
    super.key,
    required this.collectionName,
    required this.documentsCount,
    required this.onAddDoc,
    required this.onDeleteAll,
    required this.onUpdateDocs,
  });

  @override
  Widget build(BuildContext context) {
  final  provider = Provider.of<SettingsProvider>(context);
 final   textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
      margin: EdgeInsets.symmetric(horizontal: 14.w, ),
      decoration: BoxDecoration(
        color:  provider.isDark? AppTheme.black:AppTheme.white, 
        border: Border(
          bottom: BorderSide(
            color: AppTheme.boldGray.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  collectionName,
                  style: textTheme.headlineSmall
                ),
                SizedBox(height: 4.h),
                Text(
                  "$documentsCount documents",
                  style: textTheme.titleMedium
                ),
              ],
            ),
          ),
          Row(
            children: [
              _ActionButton(
                label: "Add",
                icon: Icons.add,
                color: AppTheme.green, 
                onTap: onAddDoc,
              ),
              SizedBox(width: 8.w),
              _ActionButton(
                label: "Delete",
                icon: Icons.delete_outline,
                color: AppTheme.red,
                onTap: onDeleteAll,
              ),
              SizedBox(width: 8.w),
              _ActionButton(
                label: "Update",
                icon: Icons.update,
                color: AppTheme.primary, 
                onTap: onUpdateDocs,
              ),
            ],
          ),
        ],
      ),
    );
 
 
 
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16.sp, color: color),
            SizedBox(width: 4.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}