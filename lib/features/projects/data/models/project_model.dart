class ProjectModel {
  String? id;
  String? userId;
  String? name;
  String? description;
  String? dbType;
  String? resourceTier;
  String? createdAt;
  String? password;

  ProjectModel({
    this.id,
    this.userId,
    this.name,
    this.description,
    this.dbType,
    this.resourceTier,
    this.createdAt,
    this.password
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) => ProjectModel(
    id: json['id'] as String?,
    userId: json['user_id'] as String?,
    name: json['name'] as String?,
    description: json['description'] as String?,
    dbType: json['db_type'] as String?,
    resourceTier: json['resource_tier'] as String?,
    createdAt: json['created_at'] as String?,
    password: json['password'] as String?
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'name': name,
    'description': description,
    'db_type': dbType,
    'resource_tier': resourceTier,
    'created_at': createdAt,
    'password':password
  };
}
