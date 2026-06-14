import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/core/util/ui_utils.dart';
import 'package:dbaas_project/features/settings/viewModel/settings_provider.dart';
import 'package:dbaas_project/features/sql_projects/DB/view_model/tables_cubit.dart';
import 'package:dbaas_project/features/sql_projects/DB/view_model/tables_states.dart';
import 'package:dbaas_project/features/sql_projects/index_tab/data/models/index_models.dart';
import 'package:dbaas_project/features/sql_projects/index_tab/view_model/index_cubit.dart';
import 'package:dbaas_project/features/sql_projects/index_tab/view_model/index_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class IndexFullScreen extends StatefulWidget {
  final String projectId;

  const IndexFullScreen({super.key, required this.projectId});

  @override
  State<IndexFullScreen> createState() => _IndexFullScreenState();
}

class _IndexFullScreenState extends State<IndexFullScreen> {
  String? selectedTable;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();

    final tablesState = context.read<PostgresTablesCubit>().state;
    if (tablesState is GetAllTablesSuccess &&
        tablesState.getTablesSuccessResponse.data!.isNotEmpty) {
      selectedTable = tablesState.getTablesSuccessResponse.data!.first;
      context.read<IndexCubit>().getIndexes(
        projectId: widget.projectId,
        tableName: selectedTable!,
      );
    }
  }

  late SettingsProvider provider;
  late TextTheme textTheme;
  @override
  Widget build(BuildContext context) {
    provider = Provider.of<SettingsProvider>(context);
    textTheme = Theme.of(context).textTheme;
    return BlocBuilder<PostgresTablesCubit, PostgresTablesStates>(
      builder: (context, tableState) {
        if (tableState is! GetAllTablesSuccess) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: 'Search Index',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Scaffold.of(context).openEndDrawer();
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Index'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Expanded(child: _buildIndexesContent()),
          ],
        );
      },
    );
  }

  Widget _buildIndexesContent() {
    return BlocConsumer<IndexCubit, IndexStates>(
      listener: (context, state) {
        if (state is DeleteIndexSuccess) {
          UiUtils.showSuccessMessage(context, 'Index deleted successfully');

          if (selectedTable != null) {
            context.read<IndexCubit>().getIndexes(
              projectId: widget.projectId,
              tableName: selectedTable!,
            );
          }
        }

        if (state is CreateIndexError) {
          UiUtils.showErrorMessage(context, state.error);
        }

        if (state is DeleteIndexError) {
          UiUtils.showErrorMessage(context, state.error);
        }
      },
      builder: (context, state) {
        if (selectedTable == null) {
          return Center(
            child: Text(
              'Select a table to view indexes',
              style: textTheme.titleMedium!.copyWith(
                color: provider.isDark ? AppTheme.white : AppTheme.black,
              ),
            ),
          );
        }

        if (state is GetIndexesLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is GetIndexesError) {
          return Center(child: Text(state.error));
        }

        if (state is GetIndexesSuccess) {
          final indexes = state.data.indexes;

          final filtered = indexes.where((e) {
            return e.name.toLowerCase().contains(searchQuery.toLowerCase());
          }).toList();

          if (filtered.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.dataset_outlined, size: 60),
                  const SizedBox(height: 12),
                  const Text('No Indexes Found'),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      Scaffold.of(context).openEndDrawer();
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Create Index'),
                  ),
                ],
              ),
            );
          }

          return _buildIndexesTable(filtered);
        }

        return const Center(child: Text('Select a table to view indexes'));
      },
    );
  }

  Widget _buildIndexesTable(List<PostgresTableIndexInfo> indexes) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: provider.isDark ? AppTheme.white : Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: provider.isDark ? AppTheme.white : Colors.grey.shade300,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: const Row(
              children: [
                _TableHeader(text: 'TABLE'),

                _TableHeader(text: 'COLUMN'),

                _TableHeader(text: 'INDEX NAME'),
                SizedBox(width: 60),
              ],
            ),
          ),

          const Divider(height: 1),

          Expanded(
            child: ListView.separated(
              itemCount: indexes.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final item = indexes[i];
                if (item.name.contains('pk')) {
                  return const SizedBox.shrink();
                }
                return Container(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      _TableCell(text: item.table),

                      _TableCell(text: item.columns.join(', ')),

                      _TableCell(text: item.name),

                      const SizedBox(width: 60),

                      IconButton(
                        onPressed: () {
                          context.read<IndexCubit>().deleteIndex(
                            projectId: widget.projectId,
                            tableName: item.table,
                            indexName: item.name,
                          );
                        },
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  final String text;
  const _TableHeader({required this.text});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SettingsProvider>(context);
    final textTheme = Theme.of(context).textTheme;

    return Expanded(
      child: Text(
        text,
        style: textTheme.bodySmall!.copyWith(
          fontWeight: FontWeight.bold,
          color: AppTheme.black,
        ),
      ),
    );
  }
}

class _TableCell extends StatelessWidget {
  final String text;

  const _TableCell({required this.text});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Expanded(child: Text(text, style: textTheme.bodySmall));
  }
}
