class DbInfo {
  final String database;
  final int pingTimeMs;

  DbInfo({
    required this.database,
    required this.pingTimeMs,
  });

  factory DbInfo.fromJson(Map<String, dynamic> json) {
    return DbInfo(
      database: json['database'] ?? '',
      pingTimeMs: json['ping_time_ms'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'database': database,
      'ping_time_ms': pingTimeMs,
    };
  }
}