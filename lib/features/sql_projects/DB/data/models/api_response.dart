class APIResponse<T> {
  final String status;
  final String message;
  final T? data;

  APIResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory APIResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json)? fromJsonT,
  ) {
    return APIResponse(
      status: json['status'],
      message: json['message'],
      data: fromJsonT != null && json['data'] != null
          ? fromJsonT(json['data'])
          : json['data'],
    );
  }
}