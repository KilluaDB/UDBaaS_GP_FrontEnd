import 'package:dbaas_project/features/sql_projects/DB/data/models/foreign_key_ref_request.dart';


class UpdateForeignKeys {
  final String schema;
  final String table;
  final List<ForeignKeyRef> references;

  UpdateForeignKeys({
    this.schema = 'public',
    required this.table,
    required this.references,
  });

  factory UpdateForeignKeys.fromJson(Map<String, dynamic> json) {
    return UpdateForeignKeys(
      schema: json['schema'] ?? 'public',
      table: json['table'],
      references: (json['references'] as List)
          .map((e) => ForeignKeyRef.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'schema': schema,
      'table': table,
      'references': references.map((e) => e.toJson()).toList(),
    };
  }
}