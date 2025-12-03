class User {
  final String id;
  final String name;
  final String email;
  final String createdAt;
  final String updatedAt;
  final String lastLoginAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
    required this.lastLoginAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      lastLoginAt: json['last_login_at'],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "last_login_at": lastLoginAt,
      };
}
