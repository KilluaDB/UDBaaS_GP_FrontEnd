class ProjectAccessModel {
  final String connectionString;
  final String host;
  final int port;
  final String database;
  final String username;
  final String password;
  final String? postgrestUrl;
  final String? apiKey;
  final String? jwtSecret;

  ProjectAccessModel({
    required this.connectionString,
    required this.host,
    required this.port,
    required this.database,
    required this.username,
    required this.password,
    this.postgrestUrl,
    this.apiKey,
    this.jwtSecret,
  });

  factory ProjectAccessModel.fromJson(Map<String, dynamic> json) {
    return ProjectAccessModel(
      connectionString: json['connection_string'] ?? '',
      host: json['host'] ?? '',
      port: json['port'] ?? 0,
      database: json['database'] ?? '',
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      postgrestUrl: json['postgrest_url'],
      apiKey: json['api_key'],
      jwtSecret: json['jwt_secret'],
    );
  }
}