class ForeignKeyRef {
  final String localColumn;
  final String foreignColumn;
  final String? onUpdate;
  final String? onDelete;

  ForeignKeyRef({
    required this.localColumn,
    required this.foreignColumn,
    this.onUpdate,
    this.onDelete,
  });

  factory ForeignKeyRef.fromJson(Map<String, dynamic> json) {
    return ForeignKeyRef(
      localColumn: json['local_column'],
      foreignColumn: json['foreign_column'],
      onUpdate: json['on_update'],
      onDelete: json['on_delete'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'local_column': localColumn,
      'foreign_column': foreignColumn,
      'on_update': onUpdate,
      'on_delete': onDelete,
    };
  }
}