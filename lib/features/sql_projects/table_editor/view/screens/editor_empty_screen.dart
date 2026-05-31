import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditorEmptyScreen extends StatelessWidget {
  final String tableName;
  final String projectId;

  const EditorEmptyScreen({super.key, required this.tableName,required this.projectId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header Bar
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              children: [
                Icon(Icons.storage, size: 20.sp, color: Colors.blue),
                SizedBox(width: 8.w),
                Text(tableName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
                const Spacer(),
                
                // زر الـ Insert مع القائمة المنسدلة
                PopupMenuButton<String>(
                  offset: Offset(0, 50.h),
                  onSelected: (value) {
                    if (value == 'row') {
                      // استدعي وظيفة إضافة صف من الـ Cubit
                    } else if (value == 'column') {
                      // استدعي وظيفة إضافة عمود من الـ Cubit
                    }
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: 'row',
                      child: Row(
                        children: [
                          Icon(Icons.add, color: Colors.green, size: 20.sp),
                          SizedBox(width: 10.w),
                          Text("Insert Row"),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'column',
                      child: Row(
                        children: [
                          Icon(Icons.add, color: Colors.purple, size: 20.sp),
                          SizedBox(width: 10.w),
                          Text("Insert Column"),
                        ],
                      ),
                    ),
                  ],
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.add, color: Colors.white, size: 18.sp),
                        SizedBox(width: 5.w),
                        Text("Insert", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        SizedBox(width: 5.w),
                        Icon(Icons.arrow_drop_down, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Table Header (هنا تظهر الأعمدة)
          Container(
            width: double.infinity,
            color: Colors.grey.shade50,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              children: [
                Text("id", style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 4.w),
                Icon(Icons.key, size: 14.sp, color: Colors.orange),
              ],
            ),
          ),
          
          // Empty State Content
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.storage, size: 60.sp, color: Colors.grey.shade300),
                  SizedBox(height: 16.h),
                  Text("No rows in this table", 
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 16.sp, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8.h),
                  Text("Click \"Insert\" to add your first row", 
                    style: TextStyle(color: Colors.grey.shade400)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}