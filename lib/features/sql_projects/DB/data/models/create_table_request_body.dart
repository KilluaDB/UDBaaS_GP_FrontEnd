import 'package:dbaas_project/features/sql_projects/DB/data/models/postgres_foreign_key_request.dart';
import 'package:dbaas_project/features/sql_projects/DB/data/models/table_column.dart';

class CreateTableRequestBody {
  final String schema;
  final String table;
  final List<TableColumn> columns;
 
  final List<ForeignKey>? foreignKeys;

  CreateTableRequestBody({
    this.schema = 'public',
    required this.table,
    required this.columns,
    this.foreignKeys,
  });

  factory CreateTableRequestBody.fromJson(Map<String, dynamic> json) {
    return CreateTableRequestBody(
      schema: json['schema'] ?? 'public',
      table: json['table'],
      columns: (json['columns'] as List)
          .map((e) => TableColumn.fromJson(e))
          .toList(),
      foreignKeys: json['foreign_keys'] != null
          ? (json['foreign_keys'] as List)
              .map((e) => ForeignKey.fromJson(e))
              .toList()
          : null,

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'schema': schema,
      'table': table,
      'columns': columns.map((e) => e.toJson()).toList(),
      // 'foreign_keys': foreignKeys?.map((e) => e.toJson()).toList(),
      'foreign_keys':foreignKeys
    };
  }
}