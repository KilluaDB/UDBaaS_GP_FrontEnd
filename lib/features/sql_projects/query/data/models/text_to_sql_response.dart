class SQLQueryResult {
  final List<String> columns;
  final List<Map<String, dynamic>> rows;

  SQLQueryResult({
    required this.columns,
    required this.rows,
  });

  factory SQLQueryResult.fromJson(Map<String, dynamic> json) {
    return SQLQueryResult(
      columns: List<String>.from(json["columns"] ?? []),

      rows: (json["rows"] as List? ?? [])
          .map((e) => Map<String, dynamic>.from(e))
          .toList(),
    );
  }
}

class TextToSQLResponse {
  final String sql;
  final SQLQueryResult? result;
  final String? executionId;
  final int? executionTimeMs;

  TextToSQLResponse({
    required this.sql,
    this.result,
    this.executionId,
    this.executionTimeMs,
  });

factory TextToSQLResponse.fromJson(Map<String, dynamic> json) {
  final data = json["data"];

  if (data == null) {
    throw Exception(json["message"] ?? "Invalid response");
  }

  return TextToSQLResponse(
    sql: data["sql"] ?? "",
    executionId: data["execution_id"],
    executionTimeMs: data["execution_time_ms"],
    result: data["result"] != null
        ? SQLQueryResult.fromJson(data["result"])
        : null,
  );
}
}