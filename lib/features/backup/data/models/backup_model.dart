class ImportBackupResponse {
  final String status;
  final String message;

  ImportBackupResponse({
    required this.status,
    required this.message,
  });

  factory ImportBackupResponse.fromJson(Map<String, dynamic> json) {
    return ImportBackupResponse(
      status: json['status'],
      message: json['message'],
    );
  }
}