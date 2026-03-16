class ExecuteQueryResponse {
  final SQLQueryResult? result;
  final String? executionId;
  final int? executionTimeMs;

  ExecuteQueryResponse({this.result, this.executionId, this.executionTimeMs});

  factory ExecuteQueryResponse.fromJson(Map<String, dynamic> json) => ExecuteQueryResponse(
    result: json['result'] != null ? SQLQueryResult.fromJson(json['result']) : null,
    executionId: json['execution_id'],
    executionTimeMs: json['execution_time_ms'],
  );
}

class SQLQueryResult {
  final List<String> columns; 
  final List<Map<String, dynamic>> rows; 
  final int rowCount;
  final int? rowsAffected;
  final int executionTimeMs;
  final String? error;

  SQLQueryResult({
    required this.columns,
    required this.rows,
    required this.rowCount,
    this.rowsAffected,
    required this.executionTimeMs,
    this.error,
  });

  factory SQLQueryResult.fromJson(Map<String, dynamic> json) => SQLQueryResult(
    columns: List<String>.from(json['columns']),
    rows: List<Map<String, dynamic>>.from(json['rows']),
    rowCount: json['row_count'],
    rowsAffected: json['rows_affected'],
    executionTimeMs: json['execution_time_ms'],
    error: json['error'],
  );
}