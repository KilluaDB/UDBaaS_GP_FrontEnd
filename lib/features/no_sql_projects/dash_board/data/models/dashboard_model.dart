class MongoDashboardMetrics {
  final String database;
  final int dbSizeBytes;
  final int collections;
  final int totalDocuments;
  final Last30Days last30Days;

  MongoDashboardMetrics({
    required this.database,
    required this.dbSizeBytes,
    required this.collections,
    required this.totalDocuments,
    required this.last30Days,
  });

  factory MongoDashboardMetrics.fromJson(Map<String, dynamic> json) {
    return MongoDashboardMetrics(
      database: json['database'] ?? '',
      dbSizeBytes: json['db_size_bytes'] ?? 0,
      collections: json['collections'] ?? 0,
      totalDocuments: json['total_documents'] ?? 0,
      last30Days: Last30Days.fromJson(
        json['last_30_days'] ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'database': database,
      'db_size_bytes': dbSizeBytes,
      'collections': collections,
      'total_documents': totalDocuments,
      'last_30_days': last30Days.toJson(),
    };
  }
}

class Last30Days {
  final int inserts;
  final int updates;
  final int deletes;

  Last30Days({
    required this.inserts,
    required this.updates,
    required this.deletes,
  });

  factory Last30Days.fromJson(Map<String, dynamic> json) {
    return Last30Days(
      inserts: json['inserts'] ?? 0,
      updates: json['updates'] ?? 0,
      deletes: json['deletes'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'inserts': inserts,
      'updates': updates,
      'deletes': deletes,
    };
  }
}
