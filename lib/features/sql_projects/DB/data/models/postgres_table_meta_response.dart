import 'package:dbaas_project/features/sql_projects/DB/data/models/postgres_column_detail.dart';
import 'package:dbaas_project/features/sql_projects/DB/data/models/postgres_foreign_key_response.dart';

class PostgresTableMetadata {
  final String schema;
  final String table;
  final List<PostgresColumnDetail> columns;
  final List<String> primaryKeys;
  final List<PostgresForeignKeyMeta> foreignKeys;

  PostgresTableMetadata({
    required this.schema,
    required this.table,
    required this.columns,
    required this.primaryKeys,
    required this.foreignKeys,
  });

factory PostgresTableMetadata.fromJson(Map<String, dynamic> json) {
  return PostgresTableMetadata(
    schema: json['schema'] ?? '',
    table: json['table'] ?? '',
    
    columns: (json['columns'] as List<dynamic>?)
            ?.map((e) => PostgresColumnDetail.fromJson(e))
            .toList() ?? [],
            
    primaryKeys: List<String>.from(json['primary_keys'] ?? []),
    
    foreignKeys: (json['foreign_keys'] as List<dynamic>?)
            ?.map((e) => PostgresForeignKeyMeta.fromJson(e))
            .toList() ?? [],
  );
}
  Map<String, dynamic> toJson() {
    return {
      'schema': schema,
      'table': table,
      'columns': columns.map((e) => e.toJson()).toList(),
      'primary_keys': primaryKeys,
      'foreign_keys': foreignKeys.map((e) => e.toJson()).toList(),
    };
  }
}