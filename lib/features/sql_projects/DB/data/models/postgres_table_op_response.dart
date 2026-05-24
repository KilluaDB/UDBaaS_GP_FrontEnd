import 'package:dbaas_project/features/sql_projects/DB/data/models/postgres_table_op_result.dart';

class PostgresTableOpResponse {
  final String status;
  final String message;
  final PostgresTableOpData data;

  PostgresTableOpResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory PostgresTableOpResponse.fromJson(Map<String, dynamic> json) {
    return PostgresTableOpResponse(
      status: json['status'],
      message: json['message'],
      data: PostgresTableOpData.fromJson(json['data']),
    );
  }
}

class PostgresTableOpData {
  final PostgresTableOpResult result;

  PostgresTableOpData({required this.result});

  factory PostgresTableOpData.fromJson(Map<String, dynamic> json) {
    return PostgresTableOpData(
      result: PostgresTableOpResult.fromJson(json['result']),
    );
  }
}