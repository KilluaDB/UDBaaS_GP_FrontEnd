class PostgresTableIndexInfo {
  final String name;
  final String table;
  final List<String> columns;
  final bool unique;
  final bool primary;
  final String method;
  final String definition;
  final bool valid;

  PostgresTableIndexInfo({
    required this.name,
    required this.table,
    required this.columns,
    required this.unique,
    required this.primary,
    required this.method,
    required this.definition,
    required this.valid,
  });

  factory PostgresTableIndexInfo.fromJson(
    Map<String, dynamic> json,
  ) {
    return PostgresTableIndexInfo(
      name: json['name'] ?? '',
      table: json['table'] ?? '',
      columns: List<String>.from(json['columns'] ?? []),
      unique: json['unique'] ?? false,
      primary: json['primary'] ?? false,
      method: json['method'] ?? '',
      definition: json['definition'] ?? '',
      valid: json['valid'] ?? false,
    );
  }
}
class PostgresIndexesListData {
  final List<PostgresTableIndexInfo> indexes;

  PostgresIndexesListData({
    required this.indexes,
  });

  factory PostgresIndexesListData.fromJson(
    List<dynamic> json,
  ) {
    return PostgresIndexesListData(
      indexes: json
          .map(
            (e) => PostgresTableIndexInfo.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }
}
class CreateIndexRequest {
  final String name;
  final List<String> columns;
  final bool unique;
  final String? method;

  CreateIndexRequest({
    required this.name,
    required this.columns,
    this.unique = false,
    this.method,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'columns': columns,
      'unique': unique,
      if (method != null) 'method': method,
    };
  }
}
class CreatedIndexData {
  final String name;
  final String table;
  final List<String> columns;
  final bool unique;
  final String method;

  CreatedIndexData({
    required this.name,
    required this.table,
    required this.columns,
    required this.unique,
    required this.method,
  });

  factory CreatedIndexData.fromJson(
    Map<String, dynamic> json,
  ) {
    return CreatedIndexData(
      name: json['name'] ?? '',
      table: json['table'] ?? '',
      columns: List<String>.from(json['columns'] ?? []),
      unique: json['unique'] ?? false,
      method: json['method'] ?? '',
    );
  }
}