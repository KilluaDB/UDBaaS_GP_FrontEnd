class PostgresSchemaVisualizeData {
  final String mermaid;
  final String schema;

  PostgresSchemaVisualizeData({
    required this.mermaid,
    required this.schema,
  });

  factory PostgresSchemaVisualizeData.fromJson(Map<String, dynamic> json) {
    return PostgresSchemaVisualizeData(
      mermaid: json['mermaid'] as String,
      schema: json['schema'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mermaid': mermaid,
      'schema': schema,
    };
  }
}