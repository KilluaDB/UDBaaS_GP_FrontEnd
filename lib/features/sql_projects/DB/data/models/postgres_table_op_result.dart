class PostgresTableOpResult {
  final int rowsAffected;

  PostgresTableOpResult({
    required this.rowsAffected,
  });

  factory PostgresTableOpResult.fromJson(Map<String, dynamic> json) {
    return PostgresTableOpResult(
      rowsAffected: json['rows_affected'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rows_affected': rowsAffected,
    };
  }
}