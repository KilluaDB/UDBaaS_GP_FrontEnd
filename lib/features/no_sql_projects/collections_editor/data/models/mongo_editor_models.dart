class MongoDocumentModel {
  final String id;
  final Map<String, dynamic> data;

  MongoDocumentModel({
    required this.id,
    required this.data,
  });

  factory MongoDocumentModel.fromJson(Map<String, dynamic> json) {
    return MongoDocumentModel(
      id: json['_id'].toString(),
      data: json,
    );
  }
}

class MongoGetDocumentsRequest {
  final int limit;
  final int page;

  MongoGetDocumentsRequest({
    this.limit = 20,
    this.page = 1,
  });

  Map<String, dynamic> toJson() {
    return {
      'limit': limit,
      'page': page,
    };
  }
}
class MongoGetDocumentsResult {
  final List<MongoDocumentModel> documents;
  final int total;
  final int page;
  final int limit;

  MongoGetDocumentsResult({
    required this.documents,
    required this.total,
    required this.page,
    required this.limit,
  });

  factory MongoGetDocumentsResult.fromJson(Map<String, dynamic> json) {
    return MongoGetDocumentsResult(
      documents: (json['documents'] as List)
          .map((e) => MongoDocumentModel.fromJson(e))
          .toList(),
      total: json['total'],
      page: json['page'],
      limit: json['limit'],
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
class MongoInsertDocumentsResult {
  final int insertedCount;
  final List<dynamic> insertedIds;

  MongoInsertDocumentsResult({
    required this.insertedCount,
    required this.insertedIds,
  });

  factory MongoInsertDocumentsResult.fromJson(Map<String, dynamic> json) {
    return MongoInsertDocumentsResult(
      insertedCount: json['inserted_count'],
      insertedIds: json['inserted_ids'],
    );
  }
}


class MongoUpdateDocumentsRequest {
  final Map<String, dynamic> filter;
  final Map<String, dynamic> update;
  final bool? upsert;
  final bool? updateOne;

  MongoUpdateDocumentsRequest({
    required this.filter,
    required this.update,
    this.upsert,
    this.updateOne,
  });

  Map<String, dynamic> toJson() {
    return {
      'filter': filter,
      'update': update,
      'upsert': upsert,
      'update_one': updateOne,
    };
  }
}
class MongoUpdateDocumentsResult {
  final int matched;
  final int modified;
  final String? upsertedId;

  MongoUpdateDocumentsResult({
    required this.matched,
    required this.modified,
    this.upsertedId,
  });

  factory MongoUpdateDocumentsResult.fromJson(Map<String, dynamic> json) {
    return MongoUpdateDocumentsResult(
      matched: json['matched'],
      modified: json['modified'],
      upsertedId: json['upserted_id'],
    );
  }
}


class MongoDeleteDocumentsRequest {
  final Map<String, dynamic> filter;
  final bool? deleteOne;

  MongoDeleteDocumentsRequest({
    required this.filter,
    this.deleteOne,
  });

  Map<String, dynamic> toJson() {
    return {
      'filter': filter,
      'delete_one': deleteOne,
    };
  }
}
class MongoDeleteDocumentsResult {
  final int deleted;

  MongoDeleteDocumentsResult({
    required this.deleted,
  });

  factory MongoDeleteDocumentsResult.fromJson(Map<String, dynamic> json) {
    return MongoDeleteDocumentsResult(
      deleted: json['deleted'],
    );
  }
}


class MongoCountDocumentsRequest {
  final Map<String, dynamic>? filter;

  MongoCountDocumentsRequest({this.filter});

  Map<String, dynamic> toJson() {
    return {
      'filter': filter,
    };
  }
}
class MongoCountDocumentsResult {
  final int count;

  MongoCountDocumentsResult({
    required this.count,
  });

  factory MongoCountDocumentsResult.fromJson(Map<String, dynamic> json) {
    return MongoCountDocumentsResult(
      count: json['count'],
    );
  }
}

class MongoAddFieldRequest {
  final String field;
  final dynamic defaultValue;
  final bool? updateExisting;

  MongoAddFieldRequest({
    required this.field,
    this.defaultValue,
    this.updateExisting,
  });

  Map<String, dynamic> toJson() {
    return {
      'field': field,
      'default': defaultValue,
      'update_existing': updateExisting,
    };
  }
}
class MongoUpdateFieldRequest {
  final dynamic value;

  MongoUpdateFieldRequest({required this.value});

  Map<String, dynamic> toJson() {
    return {
      'value': value,
    };
  }
}

class APIResponseSuccessMessageOnly {
  final String status;
  final String message;

  APIResponseSuccessMessageOnly({
    required this.status,
    required this.message,
  });

  factory APIResponseSuccessMessageOnly.fromJson(Map<String, dynamic> json) {
    return APIResponseSuccessMessageOnly(
      status: json['status'],
      message: json['message'],
    );
  }
}