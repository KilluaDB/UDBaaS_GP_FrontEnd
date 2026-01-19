class DeleteProjectResponse {
  String? status;
  String? message;

  DeleteProjectResponse({this.status, this.message});

  factory DeleteProjectResponse.fromJson(Map<String, dynamic> json) {
    return DeleteProjectResponse(
      status: json['status'] as String?,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {'status': status, 'message': message};
}
