class Data {
  String? id;
  String? email;
  String? role;
  String? status;
  String? createdAt;

  Data({this.id, this.email, this.role, this.status, this.createdAt});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json['id'] as String?,
    email: json['email'] as String?,
    role: json['role'] as String?,
    status: json['status'] as String?,
    createdAt: json['created_at'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'role': role,
    'status': status,
    'created_at': createdAt,
  };
}
