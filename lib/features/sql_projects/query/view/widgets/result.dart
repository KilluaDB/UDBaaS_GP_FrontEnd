import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/core/constants/app_images.dart';
import 'package:dbaas_project/core/util/ui_utils.dart';
import 'package:dbaas_project/features/settings/viewModel/settings_provider.dart';
import 'package:dbaas_project/features/sql_projects/query/view/screens/full_query_tab.dart';
import 'package:dbaas_project/features/sql_projects/query/view/widgets/empty_result.dart';
import 'package:dbaas_project/features/sql_projects/query/view_model/query_cubit.dart';
import 'package:dbaas_project/features/sql_projects/query/view_model/query_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class ResultPart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    provider = Provider.of<SettingsProvider>(context);
    textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 0.09.sw, vertical: 0.06.sh),

          decoration: BoxDecoration(
            color: provider.isDark ? AppTheme.black : AppTheme.white,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              width: 1.w,
              color: provider.isDark
                  ? AppTheme.white
                  : AppTheme.backgroundColor.withOpacity(0.1),
            ),
          ),
          child: BlocConsumer<QueryCubit, QueryStates>(
            listener: (context, state) {
              if (state is QueryExecutionLoading) {
                UiUtils.showLoading(context);
              } else {
                UiUtils.hideLoading();
              }

              if (state is QueryExecutionSuccess) {
                UiUtils.showSuccessMessage(
                  context,
                  "Query is Executed Successfully!",
                );
              }

              if (state is QueryExecutionError) {
                UiUtils.showErrorMessage(context, state.message);
              }
            },

            builder: (context, state) {
              if (state is QueryExecutionError ||
                  state is QueryExecutionLoading) {
                return EmptyResult();
              }
              if (state is QueryExecutionSuccess) {
                final executeTime = state.executeQueryResponse.executionTimeMs!;
                final rowsCount = state.executeQueryResponse.result?.rowCount;
                final result = state.executeQueryResponse.result;

                if (result == null || result.columns.isEmpty) {
                  return const Center(
                    child: Text(
                      "No data found or query executed successfully.",
                    ),
                  );
                }

                return Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: provider.isDark ? AppTheme.black : AppTheme.white,
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
                      Row(
                        children: [
                          Icon(
                            Icons.analytics_outlined,
                            size: 24.sp,
                            color: AppTheme.primary,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Query Result',
                            style: textTheme.titleMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '$rowsCount rows returned • $executeTime ms',
                        style: textTheme.bodySmall,
                      ),
                      SizedBox(height: 16.h),

                      Container(
                        height: 300.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.2),
                          ),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Scrollbar(
                          thumbVisibility: true,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                headingRowColor: WidgetStateProperty.all(
                                  AppTheme.primary.withOpacity(0.1),
                                ),
                                columnSpacing: 20.w,
                                headingRowHeight: 40.h,
                                dataRowMaxHeight: 50.h,
                                columns: result.columns
                                    .map(
                                      (col) => DataColumn(
                                        label: Text(
                                          col,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                                rows: result.rows.map((row) {
                                  return DataRow(
                                    cells: result.columns
                                        .map(
                                          (col) => DataCell(
                                            Text(
                                              row[col]?.toString() ?? "NULL",
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return EmptyResult();
            },
          ),
        ),
      ],
    );
  }
}
