class MongoGetDocumentsResponse {
  final List<Map<String, dynamic>> documents;
  final int total;
  final int page;
  final int limit;

  MongoGetDocumentsResponse({
    required this.documents,
    required this.total,
    required this.page,
    required this.limit,
  });

  factory MongoGetDocumentsResponse.fromJson(Map<String, dynamic> json) {
    return MongoGetDocumentsResponse(
      documents: (json['documents'] as List<dynamic>? ?? [])
          .map((e) => Map<String, dynamic>.from(e))
          .toList(),
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 20,
    );
  }
}
class MongoInsertDocumentsRequest {
  final List<Map<String, dynamic>> documents;

  MongoInsertDocumentsRequest({
    required this.documents,
  });

  Map<String, dynamic> toJson() {
    return {
      'documents': documents,
    };
  }
}

class MongoInsertDocumentsResponse {
  final int insertedCount;
  final List<dynamic> insertedIds;

  MongoInsertDocumentsResponse({
    required this.insertedCount,
    required this.insertedIds,
  });

  factory MongoInsertDocumentsResponse.fromJson(
      Map<String, dynamic> json) {
    return MongoInsertDocumentsResponse(
      insertedCount: json['inserted_count'] ?? 0,
      insertedIds: json['inserted_ids'] ?? [],
    );
  }
}
class MongoUpdateDocumentsRequest {
  final Map<String, dynamic>? filter;
  final Map<String, dynamic> update;
  final bool? upsert;

  MongoUpdateDocumentsRequest({
    this.filter,
    required this.update,
    this.upsert,
  });

  Map<String, dynamic> toJson() {
    return {
      if (filter != null) 'filter': filter,
      'update': update,
      if (upsert != null) 'upsert': upsert,
    };
  }
}

class MongoUpdateDocumentsResponse {
  final int matched;
  final int modified;
  final dynamic upsertedId;

  MongoUpdateDocumentsResponse({
    required this.matched,
    required this.modified,
    this.upsertedId,
  });

  factory MongoUpdateDocumentsResponse.fromJson(
      Map<String, dynamic> json) {
    return MongoUpdateDocumentsResponse(
      matched: json['matched'] ?? 0,
      modified: json['modified'] ?? 0,
      upsertedId: json['upserted_id'],
    );
  }
}


class MongoDeleteDocumentsRequest {
  final Map<String, dynamic>? filter;
  final bool? deleteOne;

  MongoDeleteDocumentsRequest({
    this.filter,
    this.deleteOne,
  });

  Map<String, dynamic> toJson() {
    return {
      if (filter != null) 'filter': filter,
      if (deleteOne != null) 'delete_one': deleteOne,
    };
  }
}

class MongoDeleteDocumentsResponse {
  final int deleted;

  MongoDeleteDocumentsResponse({
    required this.deleted,
  });

  factory MongoDeleteDocumentsResponse.fromJson(
      Map<String, dynamic> json) {
    return MongoDeleteDocumentsResponse(
      deleted: json['deleted'] ?? 0,
    );
  }
}
class MongoCountDocumentsRequest {
  final Map<String, dynamic>? filter;

  MongoCountDocumentsRequest({
    this.filter,
  });

  Map<String, dynamic> toJson() {
    return {
      if (filter != null) 'filter': filter,
    };
  }
}

class MongoCountDocumentsResponse {
  final int count;

  MongoCountDocumentsResponse({
    required this.count,
  });

  factory MongoCountDocumentsResponse.fromJson(
      Map<String, dynamic> json) {
    return MongoCountDocumentsResponse(
      count: json['count'] ?? 0,
    );
  }
}
class MongoDocumentResponse {
  final Map<String, dynamic> document;

  MongoDocumentResponse({
    required this.document,
  });

  factory MongoDocumentResponse.fromJson(
      Map<String, dynamic> json) {
    return MongoDocumentResponse(
      document: Map<String, dynamic>.from(json),
    );
  }
}
class MongoAddDocumentFieldRequest {
  final String field;
  final dynamic value;
  final String type;

  MongoAddDocumentFieldRequest({
    required this.field,
    this.value,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'field': field,
      'value': value,
      'type': type,
    };
  }
}
class MongoUpdateFieldRequest {
  final dynamic value;
  final String? type;

  MongoUpdateFieldRequest({
    required this.value,
    this.type,
  });

  Map<String, dynamic> toJson() {
  
    return {
      'value': value,
      if (type != null) 'type': type,
    };
  }
}