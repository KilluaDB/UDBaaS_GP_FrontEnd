import 'data.dart';

class User {
  String? status;
  String? message;
  Data? data;

  User({this.status, this.message, this.data});

  factory User.fromJson(Map<String, dynamic> json) => User(
    status: json['status'] as String?,
    message: json['message'] as String?,
    data: json['data'] == null
        ? null
        : Data.fromJson(json['data'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'data': data?.toJson(),
  };
    Map<String, dynamic> toJsonShowen() => {
    'email': data?.email,
  };
}
