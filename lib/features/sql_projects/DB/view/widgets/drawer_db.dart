import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/core/constants/app_images.dart';
import 'package:dbaas_project/core/util/validator.dart';
import 'package:dbaas_project/core/widgets/custome_text_form_field.dart';
import 'package:dbaas_project/features/settings/viewModel/settings_provider.dart';
import 'package:dbaas_project/features/sql_projects/DB/data/models/foreign_key_ref_request.dart';
import 'package:dbaas_project/features/sql_projects/DB/data/models/postgres_foreign_key_request.dart';
import 'package:dbaas_project/features/sql_projects/DB/data/models/table_column.dart';
import 'package:dbaas_project/features/sql_projects/DB/view_model/tables_cubit.dart';
import 'package:dbaas_project/features/sql_projects/DB/view_model/tables_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class DrawerDB extends StatefulWidget {
  final String projectId;
  const DrawerDB({super.key, required this.projectId});
  @override
  State<DrawerDB> createState() => _DrawerDBState();
}

class _DrawerDBState extends State<DrawerDB> {
  late TextEditingController tableNameController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<Map<String, dynamic>> columns = [];
  

  List<Map<String, dynamic>> foreignKeys = [];

  @override
  void initState() {
    super.initState();
    tableNameController = TextEditingController();
    
    columns.add({
      'name': TextEditingController(text: 'id'),
      'type': 'INTEGER',
      'isPrimary': true,
      'isNullable': false,
      'isUnique': true,
      'defaultValue': TextEditingController(),
    });
  }

  @override
  void dispose() {
    tableNameController.dispose();
    for (var col in columns) {
      (col['name'] as TextEditingController).dispose();
      (col['defaultValue'] as TextEditingController).dispose();
    }
    super.dispose();
  }

  void addNewColumn() {
    setState(() {
      columns.add({
        'name': TextEditingController(),
        'type': 'VARCHAR',
        'isPrimary': false,
        'isNullable': true,
        'isUnique': false,
        'defaultValue': TextEditingController(),
      });
    });
  }

  void addNewRelation() {
    setState(() {
      foreignKeys.add({'column': null, 'refTable': null, 'refColumn': null});
    });
  }

  late TextTheme textTheme;
  late SettingsProvider provider;
  late  PostgresTablesCubit tablesCubit;

  @override
  Widget build(BuildContext context) {
    textTheme = Theme.of(context).textTheme;
    provider = Provider.of<SettingsProvider>(context);
     tablesCubit = BlocProvider.of<PostgresTablesCubit>(context);

    return Drawer(
         backgroundColor: AppTheme.white,

      width: MediaQuery.of(context).size.width * 0.35,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      AppImages.appIcon,
                      width: 40.w,
                      height: 40.h,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Create a new table',
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color:  AppTheme.black,
                            ),
                          ),
                          Text(
                            'Define your table structure and relationships',
                            style: textTheme.bodySmall!.copyWith(
                             color: AppTheme.black
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                const Divider(height: 1, color: AppTheme.boldGray),
                SizedBox(height: 16.h),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionLabel(textTheme, "Table Name "),
                        SizedBox(height: 8.h),
                        CustomTextFormField(
                          controller: tableNameController,
                          validator: Validator.validateTableName,
                          hintText: 'e.g. users',
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          "Use lowercase with underscores (e.g., user_profiles)",
                          style: textTheme.bodySmall?.copyWith(
                            fontSize: 13.sp,
                         color: AppTheme.black
                          ),
                        ),
                        SizedBox(height: 24.h),

                        // Columns Header Section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildSectionLabel(
                              textTheme,
                              "Columns",
                              icon: Icons.vpn_key_outlined,
                            ),
                            ElevatedButton.icon(
                              onPressed: addNewColumn,
                              icon: const Icon(Icons.add, size: 16),
                              label: const Text("Add Column"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.white,
                                foregroundColor:  AppTheme.black,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 8.h,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "Define the structure of your table",
                          style: textTheme.bodySmall!.copyWith(color: AppTheme.black),
                        ),
                        SizedBox(height: 16.h),

                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: columns.length,
                          
                          itemBuilder: (context, index) =>
                              _buildColumnItem(index, textTheme, provider),
                        ),
                        SizedBox(height: 16.h),
                        const Divider(height: 1, color: AppTheme.boldGray),
                        SizedBox(height: 24.h),

                        _buildSectionHeader(
                          context,
                          "Foreign Key Relationships",
                          Icons.link,
                          "Link to other tables (optional)",
                          onAdd: addNewRelation,
                        ),
                        SizedBox(height: 12.h),

                        BlocBuilder<PostgresTablesCubit, PostgresTablesStates>(
                          buildWhen: (previous, current) => current is GetAllTablesSuccess,
                          builder: (context, state) {
                            List<String> availableTables = [];
                            if (state is GetAllTablesSuccess &&
                                state.getTablesSuccessResponse.data != null) {
availableTables =
    (state.getTablesSuccessResponse.data as List)
        .map((e) => e.toString())
        .toList();
                            }

                            if (availableTables.isEmpty) {
                              return _buildPlaceholderContainer(
                                textTheme,
                                provider,
                                "No existing tables available for foreign key references",
                              );
                            }

                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: foreignKeys.length,
                              itemBuilder: (context, index) =>
                                  _buildForeignKeyCard(
                                    index,
                                    textTheme,
                                    provider,
                                    availableTables,
                                  ),
                            );
                          },
                        ),

                        SizedBox(height: 24.h),
                        _buildSectionHeader(
                          context,
                          "Additional Settings",
                          Icons.settings_outlined,
                          "Configure advanced table options",
                        ),
                        SizedBox(height: 12.h),
                        _buildInfoContainer(
                          textTheme,
                          "Auto-increment enabled for SERIAL/BIGSERIAL primary keys",
                        ),
                        SizedBox(height: 32.h),
                      ],
                    ),
                  ),
                ),

                // Bottom Actions Bar
                const Divider(height: 1, color: AppTheme.boldGray),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:  AppTheme.white,
                        foregroundColor:  AppTheme.black,
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                      ),
                      child: const Text("Cancel"),
                    ),
                    SizedBox(width: 12.w),

                    BlocConsumer<PostgresTablesCubit, PostgresTablesStates>(
                      listenWhen: (previous, current) =>
                          current is CreateTableSuccess || current is CreateTableError,
                      listener: (context, state) {
                        if (state is CreateTableSuccess) {
                          Navigator.pop(context);
                     
                        } else if (state is CreateTableError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.message),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is CreateTableLoading) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24),
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          );
                        }

                        return ElevatedButton.icon(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _submitTableCreation(tablesCubit);
                            }
                          },
                          icon: const Icon(Icons.check_circle_outline, size: 16),
                          label: const Text("Create Table"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primary,
                            foregroundColor: AppTheme.white,
                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                          ),
                        );
                      },
                    ),
                  ],
                ),
             
             
             
             
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitTableCreation(PostgresTablesCubit cubit) {
final apiColumns = columns.map((col) {
    final colType = col['type'] as String;
    final isPrimary = col['isPrimary'] ?? false;
    
    final bool isNullable = col['isNullable'] ?? true; 
    final bool isUnique = col['isUnique'] ?? false;

    return TableColumn(
      name: (col['name'] as TextEditingController).text.trim(),
      type: colType,
      primary: isPrimary,
     
      nullable: isNullable, 
      isUnique: isUnique,
      isIdentity: false,
defaultValue: colType == 'SERIAL'
    ? null
    : (col['defaultValue'] as TextEditingController)
            .text
            .trim()
            .isEmpty
        ? null
        : (col['defaultValue'] as TextEditingController)
            .text
            .trim(),);
  }).toList();

  List<ForeignKey> apiForeignKeys = [];

  final validRelations = foreignKeys.where((fk) =>
      fk['column'] != null &&
      fk['refTable'] != null &&
      fk['refColumn'] != null).toList();

  for (final fk in validRelations) {
    apiForeignKeys.add(
      ForeignKey(
        schema: 'public',
        table: fk['refTable'],
        references: [
          ForeignKeyRef(
            localColumn: fk['column'],
            foreignColumn: fk['refColumn'],
          ),
        ],
      ),
    );
  }

  cubit.createTable(
    projectId: widget.projectId,
    tableName: tableNameController.text.trim(),
    columns: apiColumns,
    foreignKeys: apiForeignKeys.isEmpty ? null : apiForeignKeys,
  );
}

 
  Widget _buildForeignKeyCard(
    int index,
    TextTheme textTheme,
    SettingsProvider provider,
    List<String> availableTables,
  ) {
    List<String> currentColumnsNames = columns
        .map((col) => (col['name'] as TextEditingController).text.trim())
        .where((name) => name.isNotEmpty)
        .toList();

    if (currentColumnsNames.isEmpty) {
      currentColumnsNames = ["id"];
    }

    return Container(
      margin: EdgeInsets.only(top: 12.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color:  Colors.grey[50],
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color:  Colors.white,
                  border: Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  children: [
                    Icon(Icons.link, size: 14.sp, color: AppTheme.primary),
                    SizedBox(width: 4.w),
                    Text(
                      "Foreign Key",
                      style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold,color: AppTheme.black),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                onPressed: () => setState(() => foreignKeys.removeAt(index)),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _buildLabelAndDropdown(
                  "Column",
                  foreignKeys[index]['column'],
                  currentColumnsNames,
                  (v) => setState(() => foreignKeys[index]['column'] = v),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child:// في دالة _buildForeignKeyCard ابحث عن الجزء الخاص بـ References Table
_buildLabelAndDropdown(
  "References Table",
  foreignKeys[index]['refTable'],
  availableTables,
(v) async {
  if (v == null) return;

  setState(() {
    foreignKeys[index]['refTable'] = v;
    foreignKeys[index]['refColumn'] = null;
    foreignKeys[index]['availableColumns'] = [];
  });

  await tablesCubit.getTable(
    projectId: widget.projectId,
    tableName: v,
  );

  final tableMeta = tablesCubit.cachedTablesMap[v];

  if (tableMeta != null) {
    setState(() {
      foreignKeys[index]['availableColumns'] =
          tableMeta.columns.map((c) => c.name).toList();
    });
  }
},


),
              ),
            ],
          ),
          SizedBox(height: 16.h),
_buildLabelAndDropdown(
  "References Column",
  foreignKeys[index]['refColumn'],
  (foreignKeys[index]['availableColumns'] ?? []).cast<String>(),
  (v) {
    setState(() {
      foreignKeys[index]['refColumn'] = v;
    });
  },
),
        ],
      ),
    );
  }

  Widget _buildLabelAndDropdown(
    String label,
    String? value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    // التأكد من أن القيمة الحالية موجودة داخل الـ items لتجنب كراش الـ Dropdown الشهير في فلتر
    final String? safeValue = items.contains(value) ? value : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold,color: AppTheme.black),
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            color: provider.isDark?AppTheme.black: const Color.fromRGBO(255, 255, 255, 1),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: Colors.black12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: safeValue,
              
              dropdownColor: provider.isDark?AppTheme.black: AppTheme.white,
              hint: Text("Select...", style: TextStyle(fontSize: 12.sp)),
              items: items
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e, style: TextStyle(fontSize: 12.sp)),
                      ))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildColumnItem(
    int index,
    TextTheme textTheme,
    SettingsProvider provider,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color:  AppTheme.white,
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color:  Colors.grey[100],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text("Column ${index + 1}", style: textTheme.bodySmall!.copyWith(color: AppTheme.black)),
              ),
              if (columns[index]['isPrimary'] == true) ...[
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.amber[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.key, size: 12, color: Colors.amber),
                      SizedBox(width: 4.w),
                      Text(
                        "Primary",
                        style: textTheme.bodySmall?.copyWith(color: Colors.amber[900]),
                      ),
                    ],
                  ),
                ),
              ],
              const Spacer(),
              if (index > 0)
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                  onPressed: () => setState(() => columns.removeAt(index)),
                ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Name *", style: textTheme.bodySmall!.copyWith(color: AppTheme.black)),
                    CustomTextFormField(
                      controller: columns[index]['name'],
                      hintText: 'column_name',
                      validator: Validator.validateColumnName,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Type *", style: textTheme.bodySmall!.copyWith(color: AppTheme.black)),
                    _buildTypeDropdown(index),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
Row(
  crossAxisAlignment: CrossAxisAlignment.end,
  children: [
    if (columns[index]['type'] != 'SERIAL')
      Expanded(
        flex: 1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Default Value (optional)",
              style: textTheme.bodySmall!
                  .copyWith(color: AppTheme.black),
            ),
            SizedBox(height: 8.h),
            CustomTextFormField(
              controller: columns[index]['defaultValue'],
              hintText: 'NULL',
            ),
          ],
        ),
      ),

    if (columns[index]['type'] != 'SERIAL')
      SizedBox(width: 20.w),

    // Checkboxes section
    Expanded(
      flex: 2,
      child: Wrap(
        spacing: 16.w,
        runSpacing: 8.h,
        children: [
          _buildCheckbox(
            "Nullable",
            columns[index]['isNullable'] ?? false,
            (v) => setState(() => columns[index]['isNullable'] = v),
          ),
          _buildCheckbox(
            "Unique",
            columns[index]['isUnique'] ?? false,
            (v) => setState(() => columns[index]['isUnique'] = v),
          ),
          _buildCheckbox(
            "Primary Key",
            columns[index]['isPrimary'] ?? false,
            (v) {
              setState(() {
                for (var i = 0; i < columns.length; i++) {
                  if (i != index) {
                    columns[i]['isPrimary'] = false;
                  }
                }
                columns[index]['isPrimary'] = v;
                columns[index]['isNullable'] = false;
              });
            },
          ),
        ],
      ),
    ),
  ],
)
        
        ],
      ),
    );
  }

  Widget _buildCheckbox(String label, bool value, Function(bool) onChanged) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 24.w,
          child: Checkbox(
            value: value,
            onChanged: (v) => onChanged(v!),
            activeColor: AppTheme.primary,
          ),
        ),
        Text(label, style: TextStyle(fontSize: 11.sp)),
      ],
    );
  }

  Widget _buildTypeDropdown(int index) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(8),
        color:    
              provider.isDark?AppTheme.black: AppTheme.white,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: columns[index]['type'],
          isExpanded: true,
          
              dropdownColor: provider.isDark?AppTheme.black: AppTheme.white,
          items: ['SERIAL', 'VARCHAR', 'INTEGER', 'BOOLEAN', 'TEXT']
              .map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(e, style: TextStyle(fontSize: 12.sp)),
                  ))
              .toList(),
onChanged: (v) {
  setState(() {
    columns[index]['type'] = v;

    if (v == 'SERIAL') {
      columns[index]['isNullable'] = false;
      columns[index]['defaultValue'].clear();
    }
  });
},
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon,
    String description, {
    VoidCallback? onAdd,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(icon, size: 18, color: AppTheme.primary),
                  SizedBox(width: 8.w),
                  Text(title, style: textTheme.titleSmall!.copyWith(color: AppTheme.black)),
                ],
              ),
              Text(
                description,
                style: textTheme.titleMedium!.copyWith(fontSize: 12,color: AppTheme.black),
              ),
            ],
          ),
        ),
        if (onAdd != null)
          ElevatedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add, size: 16),
            label: const Text("Add Relation"),
            style: ElevatedButton.styleFrom(
              backgroundColor:  AppTheme.white,
              foregroundColor:  AppTheme.boldGray,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            ),
          ),
      ],
    );
  }

  Widget _buildPlaceholderContainer(TextTheme textTheme, SettingsProvider provider, String text) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color:  Colors.grey[50],
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: textTheme.bodySmall?.copyWith(color: AppTheme.black),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildInfoContainer(TextTheme textTheme, String text) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        border: Border.all(color: Colors.green[200]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, color: Colors.green, size: 16),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: textTheme.bodySmall?.copyWith(color: Colors.green[800],),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(TextTheme textTheme, String label, {IconData? icon}) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, size: 16, color: AppTheme.primary),
          SizedBox(width: 4.w),
        ],
        Text(
          label,
          style: textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold,color: AppTheme.black),
        ),
      ],
    );
  }
}