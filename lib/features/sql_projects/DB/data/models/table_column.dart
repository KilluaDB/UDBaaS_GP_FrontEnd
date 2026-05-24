class TableColumn {
  final String name;
  final String type;
  final String? defaultValue;
  final bool primary;
  final bool isUnique;
  final bool isIdentity;
  final bool nullable;

  TableColumn({
    required this.name,
    required this.type,
    this.defaultValue,
    this.primary = false,
    this.isUnique = false,
    this.isIdentity = false,
    this.nullable = true,
  });

  factory TableColumn.fromJson(Map<String, dynamic> json) {
    return TableColumn(
      name: json['name'],
      type: json['type'],
      defaultValue: json['default'],
      primary: json['primary'] ?? false,
      isUnique: json['is_unique'] ?? false,
      isIdentity: json['is_identity'] ?? false,
      nullable: json['nullable'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'default': defaultValue,
      'primary': primary,
      'is_unique': isUnique,
      'is_identity': isIdentity,
      'nullable': nullable,
    };
  }
}