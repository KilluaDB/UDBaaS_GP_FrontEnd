class DeleteResponse {
  final String message;

  DeleteResponse({required this.message});

  factory DeleteResponse.fromJson(Map<String, dynamic> json) {
    return DeleteResponse(
      message: json['message'] as String? ?? 'User deleted successfully',
    );
  }

  Map<String, dynamic> toJson() => {'message': message};
}