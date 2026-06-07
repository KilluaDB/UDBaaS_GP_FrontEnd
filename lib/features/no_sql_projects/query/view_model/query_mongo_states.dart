
import 'package:dbaas_project/features/no_sql_projects/query/data/mongo_query_models.dart';

abstract class MongoQueryState {}

class MongoQueryInitial extends MongoQueryState {}

class MongoQueryLoading extends MongoQueryState {}

class MongoQuerySuccess extends MongoQueryState {
  final MongoQueryDocumentsResult result;

  MongoQuerySuccess(this.result);
}

class MongoQueryError extends MongoQueryState {
  final String message;

  MongoQueryError(this.message);
}