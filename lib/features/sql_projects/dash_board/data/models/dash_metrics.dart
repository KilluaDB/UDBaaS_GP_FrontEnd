class PostgresDashboardMetrics {
  final String database;
  final int dbSizeBytes;
  final int activeConnections;
  final int idleConnections;
  final double cacheHitRatio;
  final int deadlocks;
  final int blockedSessions;
  final int tablesNeedingVacuum;

  PostgresDashboardMetrics({
    required this.database,
    required this.dbSizeBytes,
    required this.activeConnections,
    required this.idleConnections,
    required this.cacheHitRatio,
    required this.deadlocks,
    required this.blockedSessions,
    required this.tablesNeedingVacuum,
  });

  factory PostgresDashboardMetrics.fromJson(Map<String, dynamic> json) {
    return PostgresDashboardMetrics(
      database: json['database'] ?? '',
      dbSizeBytes: json['db_size_bytes'] ?? 0,
      activeConnections: json['active_connections'] ?? 0,
      idleConnections: json['idle_connections'] ?? 0,
      cacheHitRatio: (json['cache_hit_ratio'] ?? 0).toDouble(),
      deadlocks: json['deadlocks'] ?? 0,
      blockedSessions: json['blocked_sessions'] ?? 0,
      tablesNeedingVacuum: json['tables_needing_vacuum'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'database': database,
      'db_size_bytes': dbSizeBytes,
      'active_connections': activeConnections,
      'idle_connections': idleConnections,
      'cache_hit_ratio': cacheHitRatio,
      'deadlocks': deadlocks,
      'blocked_sessions': blockedSessions,
      'tables_needing_vacuum': tablesNeedingVacuum,
    };
  }
}