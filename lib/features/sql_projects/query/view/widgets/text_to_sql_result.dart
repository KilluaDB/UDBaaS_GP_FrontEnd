import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/features/settings/viewModel/settings_provider.dart';
import 'package:dbaas_project/features/sql_projects/query/view_model/query_cubit.dart';
import 'package:dbaas_project/features/sql_projects/query/view_model/query_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class TextToSqlResultPart extends StatelessWidget {
  const TextToSqlResultPart({super.key});

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

            if (state is TextToSQLExecutionSuccess) {
              final response = state.textToSQLResponse;
              final result = response.result;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      color: provider.isDark
                          ? Colors.grey[900]
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      response.sql,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 13.sp,
                        color: provider.isDark
                            ? Colors.greenAccent
                            : Colors.green[800],
                      ),
                    ),
                  ),

                  SizedBox(height: 12.h),
                  const Divider(),
                  SizedBox(height: 12.h),

             
                  Expanded(
                    child: result == null
                        ? Center(
                            child: Text(
                              "No results returned",
                              style: textTheme.bodySmall,
                            ),
                          )
                        : SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                headingRowColor:
                                    WidgetStateProperty.all(
                                  AppTheme.primary.withOpacity(0.05),
                                ),

                                columns: result.columns
                                    .map<DataColumn>((col) {
                                  return DataColumn(
                                    label: Text(
                                      col.toUpperCase(),
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
                                    cells: result.columns
                                        .map<DataCell>((col) {
                                      return DataCell(
                                        Text(
                                          row[col]?.toString() ?? "NULL",
                                          style: TextStyle(
                                            fontFamily: 'monospace',
                                            fontSize: 13.sp,
                                            color: provider.isDark
                                                ? Colors.white70
                                                : Colors.black87,
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
                ],
              );
            }

            if (state is TextToSQLExecutionError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline,
                        color: Colors.red, size: 48.sp),
                    SizedBox(height: 12.h),
                    Text(
                      "Text-to-SQL Error",
                      style: textTheme.titleSmall?.copyWith(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: textTheme.bodySmall,
                    ),
                  ],
                ),
              );
            }

       
            return Center(
              child: Text(
                "Ask a question to generate SQL",
                style: textTheme.bodySmall,
              ),
            );
          },
        ),
      ),
    );
  }
}