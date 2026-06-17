import 'package:dbaas_project/features/no_sql_projects/collections_editor/data/models/mongo_editor_models.dart';

abstract class MongoEditorStates {
  get message => null;
}

class MongoEditorInit extends MongoEditorStates {}
class EditModeChanged extends MongoEditorStates {}
class GetDocumentsLoading extends MongoEditorStates {}

class GetDocumentsSuccess extends MongoEditorStates {
  final MongoGetDocumentsResponse response;

  GetDocumentsSuccess(this.response);
}

class GetDocumentsError extends MongoEditorStates {
  final String message;

  GetDocumentsError(this.message);
}
class InsertDocumentsLoading extends MongoEditorStates {}

class InsertDocumentsSuccess extends MongoEditorStates {
  final MongoInsertDocumentsResponse response;

  InsertDocumentsSuccess(this.response);
}

class InsertDocumentsError extends MongoEditorStates {
  final String message;

  InsertDocumentsError(this.message);
}
class UpdateDocumentsLoading extends MongoEditorStates {}

class UpdateDocumentsSuccess extends MongoEditorStates {
  final MongoUpdateDocumentsResponse response;

  UpdateDocumentsSuccess(this.response);
}

class UpdateDocumentsError extends MongoEditorStates {
  final String message;

  UpdateDocumentsError(this.message);
}
class DeleteDocumentsLoading extends MongoEditorStates {}

class DeleteDocumentsSuccess extends MongoEditorStates {
  final MongoDeleteDocumentsResponse response;

  DeleteDocumentsSuccess(this.response);
}

class DeleteDocumentsError extends MongoEditorStates {
  final String message;

  DeleteDocumentsError(this.message);
}
class CountDocumentsLoading extends MongoEditorStates {}

class CountDocumentsSuccess extends MongoEditorStates {
  final MongoCountDocumentsResponse response;

  CountDocumentsSuccess(this.response);
}

class CountDocumentsError extends MongoEditorStates {
  final String message;

  CountDocumentsError(this.message);
}

class AddFieldLoading extends MongoEditorStates {}
class AddFieldSuccess extends MongoEditorStates {
  final String message;

  AddFieldSuccess(this.message);
}
class AddFieldError extends MongoEditorStates {
  final String message;

  AddFieldError(this.message);
}
class UpdateFieldLoading extends MongoEditorStates {}
class UpdateFieldSuccess extends MongoEditorStates {
  final String message;

  UpdateFieldSuccess(this.message);
}
class UpdateFieldError extends MongoEditorStates {
  final String message;

  UpdateFieldError(this.message);
}
class DeleteFieldLoading extends MongoEditorStates {}

class DeleteFieldSuccess extends MongoEditorStates {
  final String message;

  DeleteFieldSuccess(this.message);
}
class DeleteFieldError extends MongoEditorStates {
  final String message;

  DeleteFieldError(this.message);
}




class GetDocumentLoading extends MongoEditorStates {}

class GetDocumentSuccess extends MongoEditorStates {
  final MongoDocumentResponse response;

  GetDocumentSuccess(this.response);
}

class GetDocumentError extends MongoEditorStates {
  final String message;

  GetDocumentError(this.message);
}
class DeleteDocumentLoading extends MongoEditorStates {}

class DeleteDocumentSuccess extends MongoEditorStates {
  final String message;

  DeleteDocumentSuccess(this.message);
}
class DeleteDocumentError extends MongoEditorStates {
  final String message;

  DeleteDocumentError(this.message);
}