class ExecuteQueryResponse {
  final SQLQueryResult? result;
  final String? executionId;
  final int? executionTimeMs;
  final String? status;
  final String? message;

  ExecuteQueryResponse({
    this.result, 
    this.executionId, 
    this.executionTimeMs,
    this.status,
    this.message,
  });

  factory ExecuteQueryResponse.fromJson(Map<String, dynamic> json) {

    final dataPart = json['data'] as Map<String, dynamic>?;

    return ExecuteQueryResponse(
      status: json['status'],
      message: json['message'],
      
  
      result: dataPart != null && dataPart['result'] != null 
          ? SQLQueryResult.fromJson(dataPart['result']) 
          : null,
          
      executionId: dataPart?['execution_id'], 
      executionTimeMs: dataPart?['execution_time_ms'], 
    );
  }
}

class SQLQueryResult {
  final List<String> columns; 
  final List<Map<String, dynamic>> rows; 
  final int rowCount;
  final int? rowsAffected;
  final String? error;

  SQLQueryResult({
    required this.columns,
    required this.rows,
    required this.rowCount,
    this.rowsAffected,
    this.error,
  });

  factory SQLQueryResult.fromJson(Map<String, dynamic> json) {
    return SQLQueryResult(
   
      columns: json['columns'] != null ? List<String>.from(json['columns']) : [],
      rows: json['rows'] != null ? List<Map<String, dynamic>>.from(json['rows']) : [],
      rowCount: json['row_count'] ?? 0,
      rowsAffected: json['rows_affected'],
      error: json['error'],
    );
  }
}