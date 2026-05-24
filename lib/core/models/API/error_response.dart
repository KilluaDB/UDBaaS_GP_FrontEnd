class ErrorResponse {
  final String status;
  final String message;
  final String? error;
  final String? code;

  ErrorResponse({
    required this.status,
    required this.message,
    this.error,
    this.code,
  });

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      status: json['status'],
      message: json['message'],
      error: json['error'],
      code: json['code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'error': error,
      'code': code,
    };
  }
}