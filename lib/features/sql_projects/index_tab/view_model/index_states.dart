import 'package:dbaas_project/features/sql_projects/index_tab/data/models/index_models.dart';

abstract class IndexStates {}

class IndexInit extends IndexStates {}



class GetIndexesLoading extends IndexStates {}

class GetIndexesSuccess extends IndexStates {
  final PostgresIndexesListData data;

  GetIndexesSuccess(this.data);
}

class GetIndexesError extends IndexStates {
  final String error;

  GetIndexesError(this.error);
}



class CreateIndexLoading extends IndexStates {}

class CreateIndexSuccess extends IndexStates {
  final CreatedIndexData data;

  CreateIndexSuccess(this.data);
}

class CreateIndexError extends IndexStates {
  final String error;

  CreateIndexError(this.error);
}



class DeleteIndexLoading extends IndexStates {}

class DeleteIndexSuccess extends IndexStates {}

class DeleteIndexError extends IndexStates {
  final String error;

  DeleteIndexError(this.error);
}