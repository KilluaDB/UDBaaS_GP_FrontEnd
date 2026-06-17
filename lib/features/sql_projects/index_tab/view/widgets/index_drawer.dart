import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/core/widgets/custome_elevated_button.dart';
import 'package:dbaas_project/core/widgets/custome_text_form_field.dart';
import 'package:dbaas_project/features/settings/viewModel/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dbaas_project/features/sql_projects/DB/view_model/tables_cubit.dart';
import 'package:dbaas_project/features/sql_projects/index_tab/view_model/index_cubit.dart';
import 'package:dbaas_project/features/sql_projects/index_tab/view_model/index_states.dart';
import 'package:provider/provider.dart';

class CreateIndexDrawer extends StatefulWidget {
  final String projectId;

  const CreateIndexDrawer({super.key, required this.projectId});

  @override
  State<CreateIndexDrawer> createState() => _CreateIndexDrawerState();
}

class _CreateIndexDrawerState extends State<CreateIndexDrawer> {
  final TextEditingController indexNameController = TextEditingController();

  String? selectedTable;
  String? selectedColumn;

  List<String> columns = [];

  @override
  void dispose() {
    indexNameController.dispose();
    super.dispose();
  }

  void onTableSelected(String table) {
    final tablesCubit = context.read<PostgresTablesCubit>();

    final cached = tablesCubit.cachedTablesMap[table];

    setState(() {
      selectedTable = table;
      selectedColumn = null;

      columns = cached?.columns.map((e) => e.name).toList() ?? [];
    });
  }

  void createIndex() {
    if (selectedTable == null ||
        selectedColumn == null ||
        indexNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    final indexCubit = context.read<IndexCubit>();
    if (indexCubit.cachedIndexes != null) {
      final exists = indexCubit.cachedIndexes!.indexes.any(
        (i) =>
            i.name.toLowerCase() ==
            indexNameController.text.trim().toLowerCase(),
      );

      if (exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Index already exists locally"),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }
    }
    context.read<IndexCubit>().createIndex(
      projectId: widget.projectId,
      tableName: selectedTable!,
      name: indexNameController.text.trim(),
      columns: [selectedColumn!],
    );
  }

  late SettingsProvider provider;
  late TextTheme textTheme;
  @override
  Widget build(BuildContext context) {
    final tablesCubit = context.read<PostgresTablesCubit>();
    provider = Provider.of<SettingsProvider>(context);
    textTheme = Theme.of(context).textTheme;

    return BlocListener<IndexCubit, IndexStates>(
      listener: (context, state) {
        if (state is CreateIndexSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Index created successfully"),
              backgroundColor: Colors.green,
            ),
          );

          final table = selectedTable;

          Navigator.pop(context);

          if (table != null) {
            context.read<IndexCubit>().getIndexes(
              projectId: widget.projectId,
              tableName: table,
            );
          }
        }

        if (state is CreateIndexError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error), backgroundColor: Colors.red),
          );
        }
      },
      child: Drawer(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Create Index",
                style: textTheme.titleMedium!.copyWith(
                           color: AppTheme.black
                ),
              ),

              const SizedBox(height: 20),

              Text(
                "Table",
                style: textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  color:AppTheme.black
                ),
              ),

              BlocBuilder<PostgresTablesCubit, dynamic>(
                builder: (context, state) {
                  final tables = tablesCubit.cachedTables?.data ?? [];

                  return DropdownButtonFormField<String>(
                    dropdownColor: provider.isDark?AppTheme.black:AppTheme.white,
                    value: selectedTable,
                    hint: Text("Select Table",style: TextStyle(color: provider.isDark?AppTheme.white:AppTheme.black,),),
                    items: tables
                        .map((t) => DropdownMenuItem(value: t, child: Text(t,style: TextStyle(color: provider.isDark?AppTheme.white:AppTheme.black),)))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        onTableSelected(value);
                      }
                    },
                  );
                },
              ),

              const SizedBox(height: 16),

              Text(
                "Column",
                style: textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.bold,
                            color: AppTheme.black
                ),
              ),

              const SizedBox(height: 8),

              DropdownButtonFormField<String>(
                   dropdownColor: provider.isDark?AppTheme.black:AppTheme.white,
                value: selectedColumn,
                hint:  Text("Select Column",style: TextStyle(color: provider.isDark?AppTheme.white:AppTheme.black,),),
                items: columns
                    .map((c) => DropdownMenuItem(value: c, child: Text(c,style: TextStyle(color: provider.isDark?AppTheme.white:AppTheme.black),)))
                    .toList(),
                onChanged: (value) {
                  setState(() => selectedColumn = value);
                },
              ),

              const SizedBox(height: 16),

              Text(
                "Index Name",
                style: textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.bold,
                            color: AppTheme.black
                ),
              ),

              const SizedBox(height: 8),
CustomTextFormField( hintText: "idx_users_email",    controller: indexNameController,),
            

              const Spacer(),

              Row(
                children: [
                  Expanded(
                    child: CustomElevatedButton(
                      backgroundColor: AppTheme.black,
                      child: const Text("Cancel"),
                      onTap: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                    Expanded(
                    child: CustomElevatedButton(
                       child: const Text("Create"),
                      onTap:createIndex,
                    ),
                  ),
                  
              
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
