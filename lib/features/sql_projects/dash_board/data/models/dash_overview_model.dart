import 'package:dbaas_project/features/sql_projects/dash_board/data/models/db_info.dart';
import 'package:dbaas_project/features/sql_projects/dash_board/data/models/schema_summary.dart';

class PostgresDashboardOverview {
  final DbInfo? db;
  final SchemaSummary? schemaSummary;

  PostgresDashboardOverview({
    this.db,
    this.schemaSummary,
  });

  factory PostgresDashboardOverview.fromJson(Map<String, dynamic> json) {
    return PostgresDashboardOverview(
      db: json['db'] != null ? DbInfo.fromJson(json['db']) : null,
      schemaSummary: json['schema_summary'] != null
          ? SchemaSummary.fromJson(json['schema_summary'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'db': db?.toJson(),
      'schema_summary': schemaSummary?.toJson(),
    };
  }
}