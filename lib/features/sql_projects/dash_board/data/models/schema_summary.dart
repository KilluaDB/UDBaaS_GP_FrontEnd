class SchemaSummary {
  final int totalTables;
  final int totalColumns;
  final int totalPrimaryKeys;

  SchemaSummary({
    required this.totalTables,
    required this.totalColumns,
    required this.totalPrimaryKeys,
  });

  factory SchemaSummary.fromJson(Map<String, dynamic> json) {
    return SchemaSummary(
      totalTables: json['total_tables'] ?? 0,
      totalColumns: json['total_columns'] ?? 0,
      totalPrimaryKeys: json['total_primary_keys'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_tables': totalTables,
      'total_columns': totalColumns,
      'total_primary_keys': totalPrimaryKeys,
    };
  }
}