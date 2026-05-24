import 'package:dbaas_project/features/sql_projects/DB/data/models/update_foreign_keys.dart';

import 'table_column.dart';


class UpdateTableRequestBody {
  final String? schema;
  final String? table;
  final List<TableColumn>? columns;
  final UpdateForeignKeys? foreignKeys;

  UpdateTableRequestBody({
    this.schema,
    this.table,
    this.columns,
    this.foreignKeys,
  });

  factory UpdateTableRequestBody.fromJson(Map<String, dynamic> json) {
    return UpdateTableRequestBody(
      schema: json['schema'],
      table: json['table'],
      columns: json['columns'] != null
          ? (json['columns'] as List)
              .map((e) => TableColumn.fromJson(e))
              .toList()
          : null,
      foreignKeys: json['foreign_keys'] != null
          ? UpdateForeignKeys.fromJson(json['foreign_keys'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (schema != null) data['schema'] = schema;
    if (table != null) data['table'] = table;

    if (columns != null) {
      data['columns'] = columns!.map((e) => e.toJson()).toList();
    }

    if (foreignKeys != null) {
      data['foreign_keys'] = foreignKeys!.toJson();
    }

    return data;
  }
}