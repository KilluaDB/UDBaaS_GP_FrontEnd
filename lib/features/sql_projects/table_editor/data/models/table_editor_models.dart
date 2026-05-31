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
      rows: List<Map<String, dynamic>>.from(
        json['rows'].map((row) => Map<String, dynamic>.from(row)),
      ),
      limit: json['limit'],
      offset: json['offset'],
      hasMore: json['has_more'],
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

  Map<String, dynamic> toJson() => {
        'filter': filter,
        'update': update,
      };
}
class InsertRowResponse {
  final dynamic rowId;

  InsertRowResponse({required this.rowId});

  factory InsertRowResponse.fromJson(Map<String, dynamic> json) {
    return InsertRowResponse(
      rowId: json['row_id'],
    );
  }
}

class InsertColumnResponse {
  final int columnId;

  InsertColumnResponse({required this.columnId});

  factory InsertColumnResponse.fromJson(Map<String, dynamic> json) {
    return InsertColumnResponse(
      columnId: json['column_id'],
    );
  }
}

class InsertRowRequest {
  final Map<String, dynamic> values;

  InsertRowRequest({required this.values});

  Map<String, dynamic> toJson() => {
        'values': values,
      };
}
class InsertColumnRequest {
  final String name;
  final String type;
  final dynamic defaultValue;

  InsertColumnRequest({
    required this.name,
    required this.type,
    this.defaultValue,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'type': type,
        'default': defaultValue,
      };
}