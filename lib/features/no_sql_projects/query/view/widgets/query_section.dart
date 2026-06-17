import 'dart:convert';

import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/core/util/ui_utils.dart';
import 'package:dbaas_project/features/no_sql_projects/collections/view_model/mongo_collections_cubit.dart';
import 'package:dbaas_project/features/no_sql_projects/collections/view_model/mongo_collections_states.dart';
import 'package:dbaas_project/features/no_sql_projects/query/view_model/query_mongo_cubit.dart';
import 'package:dbaas_project/features/projects/data/models/project_model.dart';
import 'package:dbaas_project/features/settings/viewModel/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class QueryPart extends StatefulWidget {
  final ProjectModel project;

  const QueryPart({
    super.key,
    required this.project,
  });

  @override
  State createState() => _QueryPartState();
}

class _QueryPartState extends State<QueryPart> {
  late TextEditingController _queryController;

  String? selectedCollection;

  @override
  void initState() {
    super.initState();

    _queryController = TextEditingController(
      text: '''
{
  "filter": {},
  "sort": {},
  "page": 1,
  "limit": 20
}
''',
    );
  }

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SettingsProvider>(context);
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: provider.isDark ? AppTheme.black : AppTheme.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: provider.isDark
              ? Colors.white24
              : Colors.black12,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// HEADER
          Row(
            children: [
              Icon(Icons.storage, color: AppTheme.primary, size: 24.sp),
              SizedBox(width: 10.w),
              Text(
                'MongoDB Query Builder',
                style: textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: provider.isDark
                      ? AppTheme.white
                      : AppTheme.black,
                ),
              ),
            ],
          ),

          SizedBox(height: 6.h),

          Text(
            'Select collection and run JSON queries',
            style: textTheme.bodySmall!.copyWith(
              color: Colors.grey,
              fontSize: 12.sp,
            ),
          ),

          SizedBox(height: 16.h),

          /// COLLECTION DROPDOWN
          BlocBuilder<MongoCollectionsCubit, MongoCollectionsStates>(
            builder: (context, state) {
              final cubit = context.read<MongoCollectionsCubit>();
              final collections = cubit.cachedCollections;

              return Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: provider.isDark
                        ? Colors.white24
                        : Colors.black12,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  
                  child: DropdownButton<String>(
                                       dropdownColor: provider.isDark?AppTheme.black:AppTheme.white,

                    value: selectedCollection,
                    hint:  Text("Select Collection",style: TextStyle(color:  provider.isDark?AppTheme.white:AppTheme.black),),
                    isExpanded: true,
                    items: collections.map((collection) {
                      final name = collection.name ?? collection.toString();

                      return DropdownMenuItem<String>(
                        value: name,
                        child: Text(name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCollection = value;
                      });
                    },
                  ),
                ),
              );
            },
          ),

          SizedBox(height: 16.h),

          /// QUERY EDITOR
          Container(
            height: 220.h,
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: provider.isDark
                  ? Colors.grey[900]
                  : Colors.grey[50],
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: provider.isDark
                    ? Colors.white10
                    : Colors.black12,
              ),
            ),
            child: TextField(
              controller: _queryController,
              maxLines: null,
              expands: true,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 13.sp,
                color: provider.isDark
                    ? AppTheme.white
                    : AppTheme.black,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: '''
{
  "filter": {},
  "sort": {},
  "page": 1,
  "limit": 20
}
''',
              ),
            ),
          ),

          SizedBox(height: 16.h),

          /// RUN BUTTON
          Align(
            alignment: Alignment.centerLeft,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                  vertical: 12.h,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              onPressed: () {
                try {
                  if (selectedCollection == null) {
                    UiUtils.showErrorMessage(
                      context,
                      "Please select a collection first",
                    );
                    return;
                  }

                  final queryText = _queryController.text.trim();
                  final json = jsonDecode(queryText);

                  context.read<MongoQueryCubit>().queryDocuments(
                        projectId: widget.project.id!,
                        collection: selectedCollection!,
                        filter: json["filter"],
                        sort: json["sort"],
                        page: json["page"],
                        limit: json["limit"],
                      );
                } catch (e) {
                  UiUtils.showErrorMessage(
                    context,
                    "Invalid JSON format",
                  );
                }
              },
              icon: Icon(Icons.play_arrow, size: 18.sp),
              label: Text("Run Query"),
            ),
          ),
        ],
      ),
    );
  }
}