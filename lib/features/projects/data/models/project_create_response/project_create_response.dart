import '../project_model.dart';

class ProjectCreateResponse {
  String? status;
  String? message;
  ProjectModel? data;

  ProjectCreateResponse({this.status, this.message, this.data});

  factory ProjectCreateResponse.fromJson(Map<String, dynamic> json) {
    return ProjectCreateResponse(
      status: json['status'] as String?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : ProjectModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'data': data?.toJson(),
  };
}
