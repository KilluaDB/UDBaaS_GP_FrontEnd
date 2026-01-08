import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/core/constants/app_images.dart';
import 'package:dbaas_project/core/provider/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
 late TextTheme textTheme;
   late SettingsProvider provider;
class FullQueryTab extends StatefulWidget {
 
  @override
  State<FullQueryTab> createState() => _FullQueryTabState();
}

class _FullQueryTabState extends State<FullQueryTab> {
  @override
  Widget build(BuildContext context) {
      provider = Provider.of<SettingsProvider>(context);
    textTheme = Theme.of(context).textTheme;
    return SingleChildScrollView(
      child: Column(
        children: [
          _QueryPart(),
          SizedBox(height: 24.h),
          ResultPart(),
        ],
      ),
    );
  }
}

class _QueryPart extends StatelessWidget {
  final TextEditingController _queryController = TextEditingController(
    text: '-- Example: Query the ff table\nSELECT * FROM ff LIMIT 10;',
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
      color: provider.isDark?AppTheme.black:AppTheme.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          width: 1.w,
          color: provider.isDark
              ? AppTheme.white
              : AppTheme.backgroundColor.withOpacity(0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header
          Row(
            children: [
              Icon(Icons.code, size: 18.sp, color: AppTheme.primary),
              SizedBox(width: 12.w),
              Text(
                'SQL Query Editor',
                style: textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                color: provider.isDark?AppTheme.white:AppTheme.black,
                ),
              ),
            ],
          ),

          SizedBox(height: 6.h),
          Text(
            'Execute queries against your database tables',
            style: textTheme.bodySmall!.copyWith(fontSize: 12.sp,color: provider.isDark?AppTheme.white:AppTheme.black,),
          ),

          SizedBox(height: 16.h),

          /// Query editor (editable)
          Container(
            width: double.infinity,
            height: 180.h,
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
      
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: TextField(
              controller: _queryController,
              maxLines: null,
              expands: true,
              keyboardType: TextInputType.multiline,
              style: textTheme.bodySmall!.copyWith(
                fontSize: 13.sp,
                height: 1.5,
                color: provider.isDark?AppTheme.white:AppTheme.black,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Write your SQL query here...',
              ),
            ),
          ),

          SizedBox(height: 16.h),

   
          Align(
            alignment: Alignment.centerLeft,
            child: ElevatedButton.icon(
              onPressed: () {
                final query = _queryController.text;
        
              },
              icon: Icon(Icons.play_arrow, size: 18.sp),
              label: Text(
                'Execute Query',
                style: TextStyle(fontSize: 14.sp),
              ),
          
            ),
          ),
        ],
      ),
    );
  }
}

class ResultPart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
    
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: 0.09.sw,
            vertical: 0.06.sh,
          ),
    
          decoration: BoxDecoration(
                 color: provider.isDark?AppTheme.black:AppTheme.white,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              width: 1.w,
              color: provider.isDark
                  ? AppTheme.white
                  : AppTheme.backgroundColor.withOpacity(0.1),
            ),
          ),
          child: Column(
            children: [
              SvgPicture.asset(AppImages.codeLogo, width: 30.w, height: 30.h,color: AppTheme.boldGray,),
              SizedBox(height: 16.h),
              Text(
                'No results to display',
                style: textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                         color: provider.isDark?AppTheme.white:AppTheme.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12.h),
              Text(
                'Execute a query to see results here',
                style: textTheme.titleSmall!.copyWith(fontSize: 12.sp),
                textAlign: TextAlign.center,
                
              ),
              SizedBox(height: 24.h),
       
          
            ],
          ),
        ),
      ],
    );
  }
}
