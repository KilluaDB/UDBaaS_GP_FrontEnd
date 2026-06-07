import 'package:dbaas_project/features/no_sql_projects/collections_editor/data/models/mongo_editor_models.dart';

abstract class MongoEditorState {}

class MongoEditorInit extends MongoEditorState {}


class MongoDocumentsLoading extends MongoEditorState {}

class MongoDocumentsSuccess extends MongoEditorState {
  final MongoGetDocumentsResult data;

  MongoDocumentsSuccess(this.data);
}

class MongoDocumentsError extends MongoEditorState {
  final String message;

  MongoDocumentsError(this.message);
}


class MongoInsertDocumentsLoading extends MongoEditorState {}

class MongoInsertDocumentsSuccess extends MongoEditorState {
  final MongoInsertDocumentsResult data;

  MongoInsertDocumentsSuccess(this.data);
}

class MongoInsertDocumentsError extends MongoEditorState {
  final String message;

  MongoInsertDocumentsError(this.message);
}


class MongoUpdateDocumentsLoading extends MongoEditorState {}

class MongoUpdateDocumentsSuccess extends MongoEditorState {
  final MongoUpdateDocumentsResult data;

  MongoUpdateDocumentsSuccess(this.data);
}

class MongoUpdateDocumentsError extends MongoEditorState {
  final String message;

  MongoUpdateDocumentsError(this.message);
}


class MongoDeleteDocumentsLoading extends MongoEditorState {}

class MongoDeleteDocumentsSuccess extends MongoEditorState {
  final MongoDeleteDocumentsResult data;

  MongoDeleteDocumentsSuccess(this.data);
}

class MongoDeleteDocumentsError extends MongoEditorState {
  final String message;

  MongoDeleteDocumentsError(this.message);
}



class MongoCountDocumentsLoading extends MongoEditorState {}

class MongoCountDocumentsSuccess extends MongoEditorState {
  final MongoCountDocumentsResult data;

  MongoCountDocumentsSuccess(this.data);
}

class MongoCountDocumentsError extends MongoEditorState {
  final String message;

  MongoCountDocumentsError(this.message);
}


class MongoGetDocumentLoading extends MongoEditorState {}

class MongoGetDocumentSuccess extends MongoEditorState {
  final Map<String, dynamic> document;

  MongoGetDocumentSuccess(this.document);
}

class MongoGetDocumentError extends MongoEditorState {
  final String message;

  MongoGetDocumentError(this.message);
}


class MongoDeleteDocumentLoading extends MongoEditorState {}

class MongoDeleteDocumentSuccess extends MongoEditorState {}

class MongoDeleteDocumentError extends MongoEditorState {
  final String message;

  MongoDeleteDocumentError(this.message);
}


class MongoAddFieldLoading extends MongoEditorState {}

class MongoAddFieldSuccess extends MongoEditorState {}

class MongoAddFieldError extends MongoEditorState {
  final String message;

  MongoAddFieldError(this.message);
}


class MongoRemoveFieldLoading extends MongoEditorState {}

class MongoRemoveFieldSuccess extends MongoEditorState {}

class MongoRemoveFieldError extends MongoEditorState {
  final String message;

  MongoRemoveFieldError(this.message);
}


class MongoUpdateDocumentFieldLoading extends MongoEditorState {}

class MongoUpdateDocumentFieldSuccess extends MongoEditorState {}

class MongoUpdateDocumentFieldError extends MongoEditorState {
  final String message;

  MongoUpdateDocumentFieldError(this.message);
}


class MongoDeleteDocumentFieldLoading extends MongoEditorState {}

class MongoDeleteDocumentFieldSuccess extends MongoEditorState {}

class MongoDeleteDocumentFieldError extends MongoEditorState {
  final String message;

  MongoDeleteDocumentFieldError(this.message);
}