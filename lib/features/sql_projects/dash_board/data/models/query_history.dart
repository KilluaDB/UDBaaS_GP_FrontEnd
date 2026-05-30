class QueryHistoryItem {
  final String query;
  final int calls;
  final double totalTimeMs;
  final double meanTimeMs;
  final int rows;
  final int sharedBlksHit;
  final int sharedBlksRead;
  final int tempBlksWritten;

  QueryHistoryItem({
    required this.query,
    required this.calls,
    required this.totalTimeMs,
    required this.meanTimeMs,
    required this.rows,
    required this.sharedBlksHit,
    required this.sharedBlksRead,
    required this.tempBlksWritten,
  });

  factory QueryHistoryItem.fromJson(Map<String, dynamic> json) {
    return QueryHistoryItem(
      query: json['query'] ?? '',
      calls: json['calls'] ?? 0,
      totalTimeMs: (json['total_time_ms'] ?? 0).toDouble(),
      meanTimeMs: (json['mean_time_ms'] ?? 0).toDouble(),
      rows: json['rows'] ?? 0,
      sharedBlksHit: json['shared_blks_hit'] ?? 0,
      sharedBlksRead: json['shared_blks_read'] ?? 0,
      tempBlksWritten: json['temp_blks_written'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'query': query,
      'calls': calls,
      'total_time_ms': totalTimeMs,
      'mean_time_ms': meanTimeMs,
      'rows': rows,
      'shared_blks_hit': sharedBlksHit,
      'shared_blks_read': sharedBlksRead,
      'temp_blks_written': tempBlksWritten,
    };
  }
}