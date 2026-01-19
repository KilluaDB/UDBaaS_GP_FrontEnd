import 'package:dbaas_project/core/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class DrawerItem extends StatelessWidget {
  final String name;
  bool isSelected;
  bool isDelete;
  final String selectedImage;
  final String unselectedImage;

  DrawerItem({
    required this.name,
    required this.isSelected,
    required this.selectedImage,
    required this.unselectedImage,
    this.isDelete = false,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          SvgPicture.asset(
            isSelected ? selectedImage : unselectedImage,
            width: 20.w,
            height: 20.h,
            fit: BoxFit.cover,
          ),
          SizedBox(width: 12.w),
          Text(
            name,
            style: textTheme.titleMedium!.copyWith(
              color: isDelete
                  ? AppTheme.red
                  : isSelected
                  ? AppTheme.primary
                  : AppTheme.black,
            ),
          ),
        ],
      ),
    );
  }
}
