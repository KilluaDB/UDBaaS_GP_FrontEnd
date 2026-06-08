import 'package:dbaas_project/features/no_sql_projects/query/view/widgets/query_section.dart';
import 'package:dbaas_project/features/no_sql_projects/query/view/widgets/result.dart';
import 'package:dbaas_project/features/projects/data/models/project_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class FullQueryMongoTab extends StatefulWidget {
  final ProjectModel project;

  const FullQueryMongoTab({super.key, required this.project});

  @override
  State<FullQueryMongoTab> createState() => _FullQueryTabState();
}

class _FullQueryTabState extends State<FullQueryMongoTab> {


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            QueryPart(project: widget.project),

            SizedBox(height: 16.h),

            const ResultPart(),
          ],
        ),
      ),
    );
  }




}