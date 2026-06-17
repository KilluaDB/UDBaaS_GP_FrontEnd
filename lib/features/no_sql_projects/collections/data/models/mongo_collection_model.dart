class MongoCollectionsResponse {
  final List<MongoCollectionModel> collections;

  const MongoCollectionsResponse({
    required this.collections,
  });

  factory MongoCollectionsResponse.fromJson(Map<String, dynamic> json) {
    return MongoCollectionsResponse(
      collections: (json['data']['collections'] as List<dynamic>)
          .map((e) => MongoCollectionModel.fromJson(e))
          .toList(),
    );
  }
}
class MongoCollectionModel {
  final String name;

  const MongoCollectionModel({
    required this.name,
  });

  factory MongoCollectionModel.fromJson(dynamic json) {
    return MongoCollectionModel(
      name: json.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name};
  }
}


class CreateMongoCollectionRequest {
  final String name;

  const CreateMongoCollectionRequest({
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}