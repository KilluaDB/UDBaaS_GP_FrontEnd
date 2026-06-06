
import 'package:dbaas_project/features/sql_projects/schema_generation/data/data_source/schema_api_service.dart';
import 'package:dbaas_project/features/sql_projects/schema_generation/data/models/schema_generation_models.dart';
import 'package:dbaas_project/features/sql_projects/schema_generation/view_model/geneartion_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dbaas_project/features/settings/viewModel/user_provider.dart';



class SchemaGenerationCubit extends Cubit<SchemaGenerationStates> {
  final SchemaGenerationApiService _dataSource;
  final UserProvider userProvider;

  PostgresSchemaGenerationResponse? generatedSchema;

  SchemaGenerationCubit({
    required this.userProvider,
    SchemaGenerationApiService? dataSource,
  })  : _dataSource = dataSource ?? SchemaGenerationApiService(),
        super(SchemaGenerationInit());

  String? get _token => userProvider.currentUser?.data?.accessToken;


  Future<void> generateSchema({
    required String projectId,
    required String requirementText,
    String? databaseName,
    String modelName = "deepseek",
  }) async {
    emit(GenerateSchemaLoading());

    try {
      if (_token == null) {
        emit(
          GenerateSchemaError(
            "User not logged in",
          ),
        );
        return;
      }

      final response = await _dataSource.generateSchema(
        projectId: projectId,
        accessToken: _token!,
        request: GenerateSchemaRequest(
          requirementText: requirementText,
          modelName: modelName,
          databaseName: databaseName,
        ),
      );

      generatedSchema = response;

      emit(
        GenerateSchemaSuccess(
          response,
        ),
      );
    } catch (e) {
      emit(
        GenerateSchemaError(
          e.toString(),
        ),
      );
    }
  }


  Future<void> approveSchema({
    required String projectId,
  }) async {
    emit(ApproveSchemaLoading());

    try {
      if (_token == null) {
        emit(
          ApproveSchemaError(
            "User not logged in",
          ),
        );
        return;
      }

      final response = await _dataSource.approveSchema(
        projectId: projectId,
        accessToken: _token!,
      );

      emit(
        ApproveSchemaSuccess(
          response,
        ),
      );
    } catch (e) {
      emit(
        ApproveSchemaError(
          e.toString(),
        ),
      );
    }
  }


  void clearGeneratedSchema() {
    generatedSchema = null;
    emit(SchemaGenerationInit());
  }
}