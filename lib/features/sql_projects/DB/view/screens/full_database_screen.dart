import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/features/settings/viewModel/settings_provider.dart';
import 'package:dbaas_project/features/sql_projects/DB/data/models/postgres_table_meta_response.dart';
import 'package:dbaas_project/features/sql_projects/DB/view_model/tables_cubit.dart';
import 'package:dbaas_project/features/sql_projects/DB/view_model/tables_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class FullDatabaseScreen extends StatefulWidget {
  final String projectId;
  final Function(String tableName) onTableSelected;

  const FullDatabaseScreen({
    super.key,
    required this.projectId,
    required this.onTableSelected,
  });

  @override
  State<FullDatabaseScreen> createState() => _FullDatabaseScreenState();
}

class _FullDatabaseScreenState extends State<FullDatabaseScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';



  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<SettingsProvider>(context).isDark;

    return BlocConsumer<PostgresTablesCubit, PostgresTablesStates>(
     listener: (context, state) {
  if (state is CreateTableSuccess || state is DeleteTableSuccess) {
context.read<PostgresTablesCubit>().getAllTables(
  widget.projectId,
  isSilentRefresh: true,
);  }
},
      builder: (context, state) {
        final cubit = context.watch<PostgresTablesCubit>();
        final tablesList = cubit.cachedTablesMap;

        return Padding(
          padding: EdgeInsets.all(24.r),
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? AppTheme.gray : Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
            ),
            child: Column(
              children: [
                _buildHeader(isDark, tablesList.length),
                Expanded(
                  child: (state is GetAllTablesLoading && tablesList.isEmpty)
                      ? const Center(child: CircularProgressIndicator())
                      : _buildTableList(state, tablesList),
                ),
                _buildAddButton(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTableList(
    PostgresTablesStates state,
    Map<String, PostgresTableMetadata> tables,
  ) {
    final filteredEntries = tables.entries.where((entry) {
      final tableName = entry.key;
      return tableName.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    if (filteredEntries.isEmpty) {
      return const Center(child: Text('No tables found'));
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20.r),
      itemCount: filteredEntries.length,
      itemBuilder: (context, index) {
        final entry = filteredEntries[index];
        final tableName = entry.key;
        final tableMeta = entry.value;

        return TableItem(
          tableName: tableName,
          columnsCount: tableMeta.columns.length,
          onTap: () {
            widget.onTableSelected(tableName);
          },
          onDelete: () {
            context.read<PostgresTablesCubit>().deleteTable(projectId:widget.projectId,tableName: tableName);
          },

        );
      },
    );
  }

  Widget _buildHeader(bool isDark, int count) {
    return Padding(
      padding: EdgeInsets.all(20.r),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.table_chart_outlined, color: Colors.blue[600]),
              SizedBox(width: 8.w),
              Text(
                ' $count Tables available',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          TextField(
            controller: _searchController,
            onChanged: (val) {
              setState(() => _searchQuery = val);
            },
            decoration: const InputDecoration(
              hintText: 'Search tables...',
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return Builder(
      builder: (innerContext) {
        return Padding(
          padding: EdgeInsets.all(20.r),
          child: ElevatedButton.icon(
            onPressed: () {
              Scaffold.of(innerContext).openEndDrawer();
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Table'),
          ),
        );
      },
    );
  }
}

class TableItem extends StatelessWidget {
  final String tableName;
  final int columnsCount;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const TableItem({
    super.key,
    required this.tableName,
    required this.columnsCount,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<SettingsProvider>(context).isDark;

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(8.r),
          color: isDark ? Colors.white10 : Colors.white,
        ),
        child: Row(
          children: [
            Icon(Icons.table_chart, color: Colors.blue[600]),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tableName,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '$columnsCount columns',
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 14.sp),
            SizedBox(width:10.w),
            IconButton(
onPressed: () async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Delete Table'),
      content: Text(
        'Are you sure you want to delete "$tableName"? This action cannot be undone.',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: AppTheme.red, // Using your theme's red color
          ),
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Delete'),
        ),
      ],
    ),
  );

  if (confirm == true) {
    onDelete();
  }
},

 icon:  Icon(Icons.delete_outline_rounded, color: AppTheme.red,))
           
          ],
        ),
      ),
    );
  }
}
