class PostgresColumnDetail {
  final String name;
  final String dataType; 
  final String udtName; 
  final int? charMaxLength;
  final bool? isNullable; 
  final bool? isIdentity;

  PostgresColumnDetail({
    required this.name,
    required this.dataType,
    this.udtName = '', 
    this.charMaxLength,
    this.isNullable,
    this.isIdentity,
  });

  factory PostgresColumnDetail.fromJson(Map<String, dynamic> json) {
    return PostgresColumnDetail(
      name: json['name'] ?? '',
      dataType: json['data_type'] ?? '', 
      udtName: json['udt_name'] ?? '', 
      charMaxLength: json['char_max_length'],
      isNullable: json['is_nullable'] is bool ? json['is_nullable'] : false,
      isIdentity: json['is_identity'] is bool ? json['is_identity'] : false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'data_type': dataType,
      'udt_name': udtName, 
      'char_max_length': charMaxLength,
      'is_nullable': isNullable ?? false,
      'is_identity': isIdentity ?? false,
    };
  }
}