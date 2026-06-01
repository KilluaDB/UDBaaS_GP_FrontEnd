import 'package:dbaas_project/features/sql_projects/DB/data/models/postgres_foreign_key_request.dart';

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

class InsertColumnRequest {
  final String name;
  final String type;
  final dynamic defaultValue;
  final bool primary;
  final bool isUnique;
  final bool isIdentity;
  final bool nullable;
  final List<ForeignKey>? foreignKeys;

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