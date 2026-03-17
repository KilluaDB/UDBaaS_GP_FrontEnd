import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/features/settings/viewModel/settings_provider.dart';
import 'package:dbaas_project/features/sql_projects/query/view/widgets/empty_result.dart';
import 'package:dbaas_project/features/sql_projects/query/view_model/query_cubit.dart';
import 'package:dbaas_project/features/sql_projects/query/view_model/query_states.dart';
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

    return Expanded(
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(top: 16.h),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: provider.isDark ? AppTheme.black : AppTheme.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            width: 1.w,
            color: provider.isDark ? Colors.white24 : Colors.black12,
          ),
        ),
        child: BlocBuilder<QueryCubit, QueryStates>(
          builder: (context, state) {
            if (state is QueryExecutionSuccess) {
              final response = state.executeQueryResponse;
              final result = response.result;
              final executionTime = response.executionTimeMs ?? 0;

              // حالة 1: تنفيذ استعلام INSERT/UPDATE/DELETE (صفوف متأثرة فقط)
              if (result == null || (result.columns.isEmpty)) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 40.sp),
                      SizedBox(height: 10.h),
                      Text(
                        "Query Executed Successfully",
                        style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${result?.rowCount ?? 0} rows affected • $executionTime ms",
                        style: textTheme.bodySmall,
                      ),
                    ],
                  ),
                );
              }

              // حالة 2: تنفيذ استعلام SELECT (عرض جدول البيانات)
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.table_chart_outlined, size: 20.sp, color: AppTheme.primary),
                      SizedBox(width: 8.w),
                      Text("Query Result", style: textTheme.titleSmall),
                      const Spacer(),
                      Text("$executionTime ms", style: textTheme.bodySmall),
                    ],
                  ),
                  const Divider(),
                  Expanded(
                    child: Scrollbar(
                      thumbVisibility: true,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            headingRowColor: WidgetStateProperty.all(AppTheme.primary.withOpacity(0.1)),
                            columns: result.columns
                                .map<DataColumn>((col) => DataColumn(
                                      label: Text(col.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
                                    ))
                                .toList(),
                            rows: result.rows.map<DataRow>((row) {
                              return DataRow(
                                cells: result.columns
                                    .map<DataCell>((col) => DataCell(
                                          Text(row[col]?.toString() ?? "NULL"),
                                        ))
                                    .toList(),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }

            if (state is QueryExecutionError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: Colors.red, size: 40.sp),
                    SizedBox(height: 10.h),
                    Text("Execution Error", style: textTheme.titleSmall?.copyWith(color: Colors.red)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              );
            }

            // الحالة الافتراضية قبل التنفيذ
            return const EmptyResult();
          },
        ),
      ),
    );
  }
}