class DeleteTableRequestBody {
  final String schema;
  final String table;

  DeleteTableRequestBody({
    this.schema = 'public',
    required this.table,
  });

  factory DeleteTableRequestBody.fromJson(Map<String, dynamic> json) {
    return DeleteTableRequestBody(
      schema: json['schema'] ?? 'public',
      table: json['table'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'schema': schema,
      'table': table,
    };
  }
}