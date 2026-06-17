import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/core/util/validator.dart';
import 'package:dbaas_project/core/widgets/custome_text_form_field.dart';
import 'package:dbaas_project/features/sql_projects/query/view/screens/full_query_tab.dart';
import 'package:dbaas_project/features/sql_projects/table_editor/data/models/table_editor_models.dart';
import 'package:dbaas_project/features/sql_projects/table_editor/view_model/edits_cubit.dart';
import 'package:dbaas_project/features/sql_projects/table_editor/view_model/edits_states.dart';
import 'package:dbaas_project/features/sql_projects/DB/view_model/tables_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InsertColumnDrawer extends StatefulWidget {
  final String tableName;
  final String projectId;

  const InsertColumnDrawer({super.key, required this.tableName, required this.projectId});

  @override
  State<InsertColumnDrawer> createState() => _InsertColumnDrawerState();
}

class _InsertColumnDrawerState extends State<InsertColumnDrawer> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _defaultValue = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _type = 'VARCHAR';
  bool _primary = false;
  bool _unique = false;
  bool _identity = false;
  bool _nullable = true;
  bool _loading = false;

  List<Map<String, dynamic>> foreignKeysList = [];
  final types = const ['SERIAL', 'VARCHAR', 'INTEGER', 'BOOLEAN', 'TEXT'];

  void _addNewForeignKey() {
    setState(() {
      foreignKeysList.add({'refTable': null, 'refColumn': null, 'availableColumns': []});
    });
  }

  @override
  void dispose() {
    _name.dispose();
    _defaultValue.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    bool hasInvalidFK = foreignKeysList.any((fk) => fk['refTable'] == null || fk['refColumn'] == null);
    if (hasInvalidFK) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select table and column for FKs"), backgroundColor: Colors.orange));
      return;
    }

    final editor = context.read<PostgresTableEditorCubit>();
  final List<ForeignKeyColumn> fks = foreignKeysList.map((fkMap) {
      return ForeignKeyColumn(
        table: fkMap['refTable'],
        localColumn: _name.text.trim(),
        foreignColumn: fkMap['refColumn'],
      );
    }).toList();

    await editor.insertColumn(
      projectId: widget.projectId,
      tableName: widget.tableName,
      name: _name.text.trim(),
      type: _type,
      defaultValue: _type == 'SERIAL' ? null : (_defaultValue.text.trim().isEmpty ? null : _defaultValue.text.trim()),
      primary: _primary,
      isUnique: _unique,
      isIdentity: _identity,
      nullable: _nullable,
      foreignKeys: fks.isNotEmpty ? fks : null,
    );

  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final tablesCubit = context.read<PostgresTablesCubit>();
    final List<String> tableNames = tablesCubit.cachedTables?.data ?? [];

    return BlocListener<PostgresTableEditorCubit, PostgresTableEditorStates>(
      listener: (context, state) {
        setState(() => _loading = state is InsertColumnLoading);
        
if (state is InsertColumnSuccess) {
  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Column added successfully"), backgroundColor: Colors.green));
  

  final tablesCubit = context.read<PostgresTablesCubit>();
  final editorCubit = context.read<PostgresTableEditorCubit>();
  
   tablesCubit.getAllTables(widget.projectId, isSilentRefresh: true);
   editorCubit.getAllRows(projectId: widget.projectId, tableName: widget.tableName, showLoading: false);

  if (mounted) {
    Navigator.pop(context);
  }
}else if (state is InsertColumnError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.red));
        }
      },
      child: Drawer(
        width: 420.w,
        backgroundColor: AppTheme.white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildHeader(textTheme),
                const Divider(height: 1, color: AppTheme.boldGray),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel("Name *"),
                        CustomTextFormField(controller: _name, hintText: 'column_name', validator: Validator.validateColumnName),
                        SizedBox(height: 16.h),
                        _buildLabel("Type *"),
                        _buildTypeDropdown(),
                        if (_type != 'SERIAL') ...[
                          SizedBox(height: 16.h),
                          _buildLabel("Default Value"),
                          CustomTextFormField(controller: _defaultValue, hintText: 'NULL'),
                        ],
                        SizedBox(height: 24.h),
                        _buildSectionHeader("Foreign Keys", Icons.link, "Add related table constraints"),
                        ...foreignKeysList.asMap().entries.map((entry) => _buildForeignKeyCard(tablesCubit, tableNames, entry.key)),
                        TextButton.icon(onPressed: _addNewForeignKey, icon: const Icon(Icons.add, size: 18), label: const Text("Add Foreign Key")),
                        SizedBox(height: 24.h),
                        Wrap(spacing: 16.w, children: [
                          _buildCheckbox("Nullable", _nullable, (v) => setState(() => _nullable = v)),
                          _buildCheckbox("Unique", _unique, (v) => setState(() => _unique = v)),
                          _buildCheckbox("Primary", _primary, (v) => setState(() => _primary = v)),
                        ]),
                      ],
                    ),
                  ),
                ),
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForeignKeyCard(PostgresTablesCubit cubit, List<String> tableNames, int index) {
    final fk = foreignKeysList[index];
    return Container(margin: EdgeInsets.only(top: 12.h), padding: EdgeInsets.all(16.r), decoration: BoxDecoration(color: Colors.grey[50], border: Border.all(color: Colors.black12), borderRadius: BorderRadius.circular(12.r)),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text("FK #${index + 1}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          IconButton(icon: const Icon(Icons.close, size: 16, color: Colors.red), onPressed: () => setState(() => foreignKeysList.removeAt(index))),
        ]),
        _buildLabelAndDropdown("References Table", fk['refTable'], tableNames, (v) async {
          setState(() { foreignKeysList[index]['refTable'] = v; foreignKeysList[index]['refColumn'] = null; });
          await cubit.getTable(projectId: widget.projectId, tableName: v!);
          setState(() => foreignKeysList[index]['availableColumns'] = cubit.cachedTablesMap[v]?.columns.map((c) => c.name).toList());
        }),
        SizedBox(height: 12.h),
        _buildLabelAndDropdown("References Column", fk['refColumn'], (fk['availableColumns'] ?? []).cast<String>(), (v) => setState(() => foreignKeysList[index]['refColumn'] = v)),
      ]),
    );
  }

  Widget _buildHeader(TextTheme textTheme) => Padding(padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h), child: Row(children: [const Icon(Icons.add_box_outlined, color: AppTheme.primary, size: 30), SizedBox(width: 12.w), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("Add Column", style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, fontSize: 18)), Text("To: ${widget.tableName}", style: textTheme.bodySmall?.copyWith(color: AppTheme.boldGray))])]));

  Widget _buildFooter() => Container(padding: EdgeInsets.all(16.r), decoration: const BoxDecoration(border: Border(top: BorderSide(color: Colors.black12))), child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
    ElevatedButton(onPressed: () => Navigator.pop(context), style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black), child: const Text("Cancel")),
    SizedBox(width: 12.w),
    ElevatedButton(onPressed: _loading ? null : _submit, child: _loading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text("Add Column")),
  ]));

  Widget _buildLabel(String text) => Padding(padding: EdgeInsets.only(bottom: 8.h), child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)));
  Widget _buildSectionHeader(String title, IconData icon, String desc) => Row(children: [Icon(icon, size: 18, color: AppTheme.primary), SizedBox(width: 8.w), Text(title, style: const TextStyle(fontWeight: FontWeight.bold))]);
  Widget _buildTypeDropdown() => Container(padding: EdgeInsets.symmetric(horizontal: 12.w), decoration: BoxDecoration(border: Border.all(color: Colors.black12), color:provider.isDark? AppTheme.black:AppTheme.white, borderRadius: BorderRadius.circular(8.r)), child: DropdownButtonHideUnderline(child: DropdownButton<String>(dropdownColor: provider.isDark? AppTheme.black:AppTheme.white,value: _type, isExpanded: true, items: types.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (v) => setState(() => _type = v!))));
  Widget _buildLabelAndDropdown(String label, String? value, List<String> items, Function(String?) onChanged) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)), SizedBox(height: 8.h), Container(padding: EdgeInsets.symmetric(horizontal: 12.w), decoration: BoxDecoration(border: Border.all(color: Colors.black12), borderRadius: BorderRadius.circular(8.r)), child: DropdownButtonHideUnderline(child: DropdownButton<String>(isExpanded: true, value: items.contains(value) ? value : null, items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: onChanged)))]);
  Widget _buildCheckbox(String label, bool value, Function(bool) onChanged) => Row(mainAxisSize: MainAxisSize.min, children: [Checkbox(value: value, onChanged: (v) => onChanged(v!), activeColor: AppTheme.primary), Text(label, style: const TextStyle(fontSize: 12))]);
}