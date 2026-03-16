import 'package:dbaas_project/features/projects/data/models/project_model.dart';

class GetProjectsResponse {
  String? status;
  String? message;
  List<ProjectModel>? data;

  GetProjectsResponse({this.status, this.message, this.data});

factory GetProjectsResponse.fromJson(Map<String, dynamic> json) {
  return GetProjectsResponse(
    status: json['status'] as String?,
    message: json['message'] as String?,

    data: json['data'] != null 
        ? (json['data'] as List).map((e) => ProjectModel.fromJson(e as Map<String, dynamic>)).toList()
        : [], 
  );
}

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'data': data?.map((e) => e.toJson()).toList(),
  };
}
