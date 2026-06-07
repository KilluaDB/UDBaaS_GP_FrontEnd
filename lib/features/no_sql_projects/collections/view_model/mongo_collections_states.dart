import '../data/models/mongo_collection_model.dart';

abstract class MongoCollectionsStates {}

/// INIT
class MongoCollectionsInit extends MongoCollectionsStates {}

/// GET ALL COLLECTIONS
class GetMongoCollectionsLoading extends MongoCollectionsStates {}

class GetMongoCollectionsSuccess extends MongoCollectionsStates {
  final List<MongoCollectionModel> collections;

  GetMongoCollectionsSuccess(this.collections);
}

class GetMongoCollectionsError extends MongoCollectionsStates {
  final String message;

  GetMongoCollectionsError(this.message);
}

/// CREATE COLLECTION
class CreateMongoCollectionLoading extends MongoCollectionsStates {}

class CreateMongoCollectionSuccess extends MongoCollectionsStates {
  final MongoCollectionModel collection;

  CreateMongoCollectionSuccess(this.collection);
}

class CreateMongoCollectionError extends MongoCollectionsStates {
  final String message;

  CreateMongoCollectionError(this.message);
}

/// DELETE COLLECTION
class DeleteMongoCollectionLoading extends MongoCollectionsStates {}

class DeleteMongoCollectionSuccess extends MongoCollectionsStates {
  final MongoCollectionModel collection;

  DeleteMongoCollectionSuccess(this.collection);
}

class DeleteMongoCollectionError extends MongoCollectionsStates {
  final String message;

  DeleteMongoCollectionError(this.message);
}