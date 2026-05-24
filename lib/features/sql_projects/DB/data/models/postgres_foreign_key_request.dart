import 'package:dbaas_project/features/sql_projects/DB/data/models/foreign_key_ref_request.dart';

class ForeignKey {
  final String schema;
  final String table;
  final List<ForeignKeyRef> references;

  ForeignKey({
    this.schema = 'public',
    required this.table,
    required this.references,
  });

  factory ForeignKey.fromJson(Map<String, dynamic> json) {
    return ForeignKey(
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