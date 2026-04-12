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
              final int displayCount;
              final bool isSelection = result != null && result.columns.isNotEmpty;

              if (isSelection) {
                displayCount = result.rows.length;
              } else {
                displayCount = result?.rowsAffected ?? 0;
              }

              if (!isSelection) {
                return _buildSuccessMessage(textTheme, displayCount, executionTime, isSelection: false);
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildResultHeader(textTheme, executionTime, displayCount, provider),
                  const Divider(),
                  Expanded(
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        scrollbarTheme: ScrollbarThemeData(
                          thumbColor: WidgetStateProperty.all(AppTheme.primary.withOpacity(0.5)),
                        ),
                      ),
                      child: Scrollbar(
                        thumbVisibility: true,
                        trackVisibility: true,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              headingRowColor: WidgetStateProperty.all(AppTheme.primary.withOpacity(0.05)),
                              dataRowMinHeight: 48.h,
                              columnSpacing: 24.w,
                              horizontalMargin: 12.w,
                              border: TableBorder.all(
                                color: provider.isDark ? Colors.white10 : Colors.black12,
                                width: 0.5,
                              ),
                              columns: result.columns.map<DataColumn>((col) {
                                return DataColumn(
                                  label: Text(
                                    col.toString().toUpperCase(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primary,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                );
                              }).toList(),
                              rows: result.rows.map<DataRow>((row) {
                                return DataRow(
                                  cells: result.columns.map<DataCell>((col) {
                                    final value = row[col];
                                    return DataCell(
                                      Text(
                                        value?.toString() ?? "NULL",
                                        style: TextStyle(
                                          fontSize: 13.sp,
                                          color: value == null ? Colors.grey : (provider.isDark ? Colors.white70 : Colors.black87),
                                          fontFamily: 'monospace',
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }

            if (state is QueryExecutionError) {
              return _buildErrorMessage(textTheme, state.message);
            }

            return const EmptyResult();
          },
        ),
      ),
    );
  }


  Widget _buildResultHeader(TextTheme textTheme, int executionTime, int count, SettingsProvider provider) {
    return Row(
      children: [
        Icon(Icons.table_chart_outlined, size: 20.sp, color: AppTheme.primary),
        SizedBox(width: 8.w),
        Text("Query Result ($count rows)", 
          style: textTheme.titleSmall!.copyWith(
            color: provider.isDark ? AppTheme.white : AppTheme.black
          )
        ),
        const Spacer(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Text("$executionTime ms", 
            style: textTheme.bodySmall?.copyWith(
              color: Colors.green, 
              fontWeight: FontWeight.bold
            )
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessMessage(TextTheme textTheme, int count, int time, {required bool isSelection}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 48.sp),
          SizedBox(height: 12.h),
          Text("Query Executed Successfully", 
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          SizedBox(height: 4.h),
          Text(
            isSelection 
              ? "$count rows retrieved • $time ms" 
              : "$count rows affected • $time ms",
            style: textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorMessage(TextTheme textTheme, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 48.sp),
          SizedBox(height: 12.h),
          Text("Execution Error", 
            style: textTheme.titleSmall?.copyWith(color: Colors.red, fontWeight: FontWeight.bold)),
          Padding(
            padding: EdgeInsets.all(20.r),
            child: Text(message, textAlign: TextAlign.center, style: textTheme.bodySmall),
          ),
        ],
      ),
    );
  }
}