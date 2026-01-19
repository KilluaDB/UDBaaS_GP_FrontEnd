class LogoutResponse {
  String? message;

  LogoutResponse({this.message});

  factory LogoutResponse.fromJson(Map<String, dynamic> json) {
    return LogoutResponse(message: json['message'] as String?);
  }

  Map<String, dynamic> toJson() => {'message': message};
}
