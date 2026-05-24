
class PostgresListTablesResponse {
  final String? status;
  final String? message;
  final List<String>? data;

  PostgresListTablesResponse({this.status, this.message, this.data});

  factory PostgresListTablesResponse.fromJson(Map<String, dynamic> json) {
    return PostgresListTablesResponse(
      status: json['status'] as String?,
      message: json['message'] as String?,
      data: json['data'] != null ? List<String>.from(json['data'].map((x) => x.toString())) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data,
    };
  }
}