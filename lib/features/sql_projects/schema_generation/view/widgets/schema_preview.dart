import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/core/widgets/custome_elevated_button.dart';
import 'package:dbaas_project/features/settings/viewModel/settings_provider.dart';
import 'package:dbaas_project/features/sql_projects/query/view/screens/full_query_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SchemaPreview extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    SettingsProvider settings = Provider.of<SettingsProvider>(context);
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      decoration: BoxDecoration(
        border: BoxBorder.all(width: 0.5, color: AppTheme.boldGray),
        borderRadius: BorderRadius.circular(14),
        color: settings.isDark ? AppTheme.black : AppTheme.white,
      ),
      child: Column(
     
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.schema_outlined,
                color: AppTheme.primary,
                size: 20,
              ),
              SizedBox(width: 8.w),
              Text(
                "Schema Preview",
                style: textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: settings.isDark ? AppTheme.white : AppTheme.black,
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Text(
            
            "Upload data or use AI chat to generate schema",
            style: textTheme.titleSmall!.copyWith(
              color: settings.isDark ? AppTheme.white : AppTheme.black,
            ),
       
          ),
          SizedBox(height: 24.h,),
          Container(
            padding: EdgeInsets.symmetric(vertical: 30),
            width: double.infinity,
           
            decoration: BoxDecoration(
              color: AppTheme.semiGray
              ,
              borderRadius: BorderRadius.circular(10),
              
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.schema_outlined,size:48 ,color:AppTheme.boldGray ,),
                SizedBox(height: 16.h,),
                Text("No schema generated yet",style: textTheme.titleMedium!.copyWith(color: AppTheme.boldGray),),
                   SizedBox(height: 8.h,),
                Text("Upload a file or describe your needs in the AI chat",style: textTheme.titleMedium!.copyWith(color: AppTheme.boldGray),),
              ],
            ),
          )
        ],
      ),
    );
  }
}
