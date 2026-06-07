class MongoCollectionModel {
  final String name;

  const MongoCollectionModel({
    required this.name,
  });

  factory MongoCollectionModel.fromJson(Map<String, dynamic> json) {
    return MongoCollectionModel(
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
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