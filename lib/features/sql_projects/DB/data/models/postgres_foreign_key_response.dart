class PostgresForeignKeyMeta {
  final String constraintName;
  final String fromColumn;
  final String toSchema;
  final String toTable;
  final String toColumn;
  final String updateRule;
  final String deleteRule;

  PostgresForeignKeyMeta({
    required this.constraintName,
    required this.fromColumn,
    required this.toSchema,
    required this.toTable,
    required this.toColumn,
    required this.updateRule,
    required this.deleteRule,
  });

  factory PostgresForeignKeyMeta.fromJson(Map<String, dynamic> json) {
    return PostgresForeignKeyMeta(
      constraintName: json['constraint_name'],
      fromColumn: json['from_column'],
      toSchema: json['to_schema'],
      toTable: json['to_table'],
      toColumn: json['to_column'],
      updateRule: json['update_rule'],
      deleteRule: json['delete_rule'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'constraint_name': constraintName,
      'from_column': fromColumn,
      'to_schema': toSchema,
      'to_table': toTable,
      'to_column': toColumn,
      'update_rule': updateRule,
      'delete_rule': deleteRule,
    };
  }
}