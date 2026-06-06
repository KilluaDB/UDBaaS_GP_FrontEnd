
class GetRowsResponse {
  final List<Map<String, dynamic>> rows;
  final int limit;
  final int offset;
  final bool hasMore;
  final int? total;

  GetRowsResponse({
    required this.rows,
    required this.limit,
    required this.offset,
    required this.hasMore,
    this.total,
  });

  factory GetRowsResponse.fromJson(Map<String, dynamic> json) {
    return GetRowsResponse(
      rows: (json['rows'] as List? ?? [])
          .map((row) => Map<String, dynamic>.from(row))
          .toList(),
      limit: json['limit'] ?? 0,
      offset: json['offset'] ?? 0,
      hasMore: json['has_more'] ?? false,
      total: json['total'],
    );
  }
}

class UpdateRowsRequest {
  final Map<String, dynamic>? filter;
  final Map<String, dynamic> update;

  UpdateRowsRequest({
    this.filter,
    required this.update,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'update': update,
    };

    if (filter != null) {
      data['filter'] = filter;
    }

    return data;
  }
}

class InsertRowRequest {
  final Map<String, dynamic> values;

  InsertRowRequest({
    required this.values,
  });

  Map<String, dynamic> toJson() => {
        'values': values,
      };
}

class InsertRowResponse {
  final dynamic rowId;

  InsertRowResponse({
    required this.rowId,
  });

  factory InsertRowResponse.fromJson(Map<String, dynamic> json) {
    return InsertRowResponse(
      rowId: json['row_id'],
    );
  }
}

class InsertColumnResponse {
  final int columnId;

  InsertColumnResponse({
    required this.columnId,
  });

  factory InsertColumnResponse.fromJson(Map<String, dynamic> json) {
    return InsertColumnResponse(
      columnId: json['column_id'],
    );
  }
}



class ForeignKeyColumn {
  final String schema;
  final String table;
  final String localColumn;
  final String foreignColumn;
  final String? onUpdate;
  final String? onDelete;

  ForeignKeyColumn({
    this.schema = 'public',
    required this.table,
    required this.localColumn,
    required this.foreignColumn,
    this.onUpdate,
    this.onDelete,
  });

  factory ForeignKeyColumn.fromJson(Map<String, dynamic> json) {
    return ForeignKeyColumn(
      schema: json['schema'] ?? 'public',
      table: json['table'],
      localColumn: json['local_column'],
      foreignColumn: json['foreign_column'],
      onUpdate: json['on_update'],
      onDelete: json['on_delete'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'schema': schema,
      'table': table,
      'local_column': localColumn,
      'foreign_column': foreignColumn,
      'on_update': onUpdate,
      'on_delete': onDelete,
    };
  }
}
class InsertColumnRequest {
  final String name;
  final String type;
  final dynamic defaultValue;
  final bool primary;
  final bool isUnique;
  final bool isIdentity;
  final bool nullable;
  final List<ForeignKeyColumn>? foreignKeys;

  InsertColumnRequest({
    required this.name,
    required this.type,
    this.defaultValue,
    this.primary = false,
    this.isUnique = false,
    this.isIdentity = false,
    this.nullable = true,
    this.foreignKeys,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'name': name,
      'type': type,
      'primary': primary,
      'is_unique': isUnique,
      'is_identity': isIdentity,
      'nullable': nullable,
    };

    if (defaultValue != null) {
      data['default'] = defaultValue;
    }

    if (foreignKeys != null && foreignKeys!.isNotEmpty) {
      data['foreign_keys'] =
          foreignKeys!.map((fk) => fk.toJson()).toList();
    }

    return data;
  }
}