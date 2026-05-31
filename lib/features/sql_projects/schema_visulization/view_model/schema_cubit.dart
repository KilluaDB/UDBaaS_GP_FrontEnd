import 'package:dbaas_project/features/settings/viewModel/user_provider.dart';
import 'package:dbaas_project/features/sql_projects/schema_visulization/data/data_source/schema_api_service.dart';
import 'package:dbaas_project/features/sql_projects/schema_visulization/view_model/schema_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SchemaCubit extends Cubit<SchemaStates> {
 final SchemaApiService _dataSource;
  final UserProvider userProvider;
String fixMermaid(String input) {
  return input.replaceAll(': ""', ': "rel"');
}

  SchemaCubit({required this.userProvider, SchemaApiService? dataSource})
      : _dataSource = dataSource ?? SchemaApiService(),
        super(SchemaInit());

  Future<void> visualizeSchema({
    required String projectId,
    String schema = "public",
  }) async {
    emit(PostgresSchemaVisualizationLoading());

    try {
          final accessToken = userProvider.currentUser?.data?.accessToken;
      
      if (accessToken == null || accessToken.isEmpty) {
        emit(PostgresSchemaVisualizationError("User session expired. Please login again."));
        return;
      }
      final response = await _dataSource. visualizePostgresSchema(
        projectId: projectId,
        accessToken: accessToken,
        schema: schema,
      );

      emit(PostgresSchemaVisualizationSuccess(response));
    } catch (e) {
      emit(
        PostgresSchemaVisualizationError(
          e.toString(),
        ),
      );
    }
  }
}