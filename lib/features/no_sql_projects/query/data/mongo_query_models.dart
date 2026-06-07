class MongoQueryDocumentsRequest {
  final Map<String, dynamic>? filter;
  final Map<String, dynamic>? sort;
  final int? page;
  final int? limit;

  MongoQueryDocumentsRequest({
    this.filter,
    this.sort,
    this.page,
    this.limit,
  });

  Map<String, dynamic> toJson() {
    return {
      if (filter != null) "filter": filter,
      if (sort != null) "sort": sort,
      if (page != null) "page": page,
      if (limit != null) "limit": limit,
    };
  }

  factory MongoQueryDocumentsRequest.fromJson(Map<String, dynamic> json) {
    return MongoQueryDocumentsRequest(
      filter: json["filter"],
      sort: json["sort"],
      page: json["page"],
      limit: json["limit"],
    );
  }
}
class MongoQueryDocumentsResult {
  final List<Map<String, dynamic>> documents;
  final int total;
  final int page;
  final int limit;

  MongoQueryDocumentsResult({
    required this.documents,
    required this.total,
    required this.page,
    required this.limit,
  });

  factory MongoQueryDocumentsResult.fromJson(Map<String, dynamic> json) {
    return MongoQueryDocumentsResult(
      documents: List<Map<String, dynamic>>.from(
        json["documents"] ?? [],
      ),
      total: json["total"] ?? 0,
      page: json["page"] ?? 1,
      limit: json["limit"] ?? 10,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "documents": documents,
      "total": total,
      "page": page,
      "limit": limit,
    };
  }
}