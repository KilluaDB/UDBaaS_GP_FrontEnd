import 'dart:convert';

import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/features/no_sql_projects/query/data/mongo_query_models.dart';
import 'package:dbaas_project/features/no_sql_projects/query/view/widgets/empty_result.dart';
import 'package:dbaas_project/features/no_sql_projects/query/view_model/query_mongo_cubit.dart';
import 'package:dbaas_project/features/no_sql_projects/query/view_model/query_mongo_states.dart';
import 'package:dbaas_project/features/settings/viewModel/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ResultPart extends StatelessWidget {
  const ResultPart({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SettingsProvider>(context);
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 16.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: provider.isDark ? AppTheme.black : AppTheme.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: provider.isDark ? Colors.white12 : Colors.black12,
        ),
      ),
      child: BlocBuilder<MongoQueryCubit, MongoQueryState>(
        builder: (context, state) {

          /// LOADING
          if (state is MongoQueryLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          /// SUCCESS
          if (state is MongoQuerySuccess) {

            // final result = state.result;
                      final result = MongoQueryDocumentsResult(


documents: [
{
"_id": "64a1",
"name": "Ahmed Ali",
"email": "ahmed@demo.com",
"age": 25,
"status": "active",
"city": "Cairo"
},
{
"_id": "64a2",
"name": "Sara Mohamed",
"email": "sara@demo.com",
"age": 30,
"status": "inactive",
"city": "Alex"
},
{
"_id": "64a3",
"name": "Omar Khaled",
"email": "omar@demo.com",
"age": 22,
"status": "active",
"city": "Giza"
}
],
total: 3,
page: 1,
limit: 10,
);

            if (result.documents.isEmpty) {
              return const EmptyResult();
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(
                  textTheme,
                  provider,
                  result.total,
                  result.page,
                  result.limit,
                ),

                SizedBox(height: 12.h),
                const Divider(),

                /// ❗ NO Expanded, NO inner scroll
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: result.documents.length,
                  separatorBuilder: (_, __) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    final doc = result.documents[index];

                    return Container(
                      padding: EdgeInsets.all(12.r),
                      decoration: BoxDecoration(
                        color: provider.isDark
                            ? Colors.grey[900]
                            : Colors.grey[50],
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: provider.isDark
                              ? Colors.white10
                              : Colors.black12,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: doc.entries.map((entry) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 3.h),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${entry.key}: ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.sp,
                                    color: AppTheme.primary,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    _formatValue(entry.value),
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontFamily: 'monospace',
                                      color: provider.isDark
                                          ? Colors.white70
                                          : Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
              ],
            );
          }

          /// ERROR
          if (state is MongoQueryError) {
            return _buildError(textTheme, state.message);
          }

          return const EmptyResult();
        },
      ),
    );
  }

  Widget _buildHeader(
    TextTheme textTheme,
    SettingsProvider provider,
    int total,
    int page,
    int limit,
  ) {
    return Row(
      children: [
        Icon(Icons.table_chart, size: 20.sp, color: AppTheme.primary),
        SizedBox(width: 8.w),
        Text(
          "$total Documents",
          style: textTheme.titleSmall!.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
          decoration: BoxDecoration(
            color: AppTheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: Text(
            "Page $page • Limit $limit",
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.bold,
              color: AppTheme.primary,
            ),
          ),
        ),
      ],
    );
  }

  String _formatValue(dynamic value) {
    if (value == null) return "NULL";
    if (value is Map || value is List) {
      return jsonEncode(value);
    }
    return value.toString();
  }

  Widget _buildError(
    TextTheme textTheme,
    String message,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48.sp, color: Colors.red),
          SizedBox(height: 10.h),
          Text(
            "Query Failed",
            style: textTheme.titleMedium!.copyWith(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}