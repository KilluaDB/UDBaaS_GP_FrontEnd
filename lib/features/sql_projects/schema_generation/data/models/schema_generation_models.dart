
class GenerateSchemaRequest {
  final String requirementText;
  final String? modelName;
  final String? databaseName;

  GenerateSchemaRequest({
    required this.requirementText,
    this.modelName,
    this.databaseName,
  });

  Map<String, dynamic> toJson() {
    return {
      "requirement_text": requirementText,
      if (modelName != null) "model_name": modelName,
      if (databaseName != null) "database_name": databaseName,
    };
  }
}

class PostgresSchemaGenerationData {
  final String mermaid;
  final bool mmdValid;
  final String dbSchema;
  final String fullReport;
  final String ddl;
  final List<String> indexStatements;
  final num generationTime;

  PostgresSchemaGenerationData({
    required this.mermaid,
    required this.mmdValid,
    required this.dbSchema,
    required this.fullReport,
    required this.ddl,
    required this.indexStatements,
    required this.generationTime,
  });

  factory PostgresSchemaGenerationData.fromJson(
    Map<String, dynamic> json,
  ) {
    return PostgresSchemaGenerationData(
      mermaid: json['mermaid'] ?? '',
      mmdValid: json['mmd_valid'] ?? false,
      dbSchema: json['db_schema'] ?? '',
      fullReport: json['full_report'] ?? '',
      ddl: json['ddl'] ?? '',
      indexStatements:
          (json['index_statements'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      generationTime: json['generation_time'] ?? 0,
    );
  }
}

class PostgresSchemaGenerationResponse {
  final String status;
  final String message;
  final PostgresSchemaGenerationData data;

  PostgresSchemaGenerationResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory PostgresSchemaGenerationResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return PostgresSchemaGenerationResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: PostgresSchemaGenerationData.fromJson(
        json['data'] ?? {},
      ),
    );
  }
}

class ApproveSchemaResponse {
  final String status;
  final String message;

  ApproveSchemaResponse({
    required this.status,
    required this.message,
  });

  factory ApproveSchemaResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return ApproveSchemaResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
    );
  }
}

class SchemaStreamEvent {
  final String type;
  final String? phase;
  final String? status;
  final String? content;
  final bool? valid;
  final String? message;

  SchemaStreamEvent({
    required this.type,
    this.phase,
    this.status,
    this.content,
    this.valid,
    this.message,
  });

  factory SchemaStreamEvent.fromJson(
    Map<String, dynamic> json,
  ) {
    return SchemaStreamEvent(
      type: json['type'] ?? '',
      phase: json['phase'],
      status: json['status'],
      content: json['content'],
      valid: json['valid'],
      message: json['message'],
    );
  }
}