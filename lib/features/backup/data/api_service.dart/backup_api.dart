import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

import 'package:dbaas_project/core/constants/api_constants.dart';
import 'package:dbaas_project/core/helper/api_error_handler.dart';
import 'package:dbaas_project/features/backup/data/models/backup_model.dart';

class BackupApiService {
  Map<String, String> _headers(String token) => {
        'Authorization': 'Bearer $token',
      };

  
  Future<Uint8List> exportProject({
    required String token,
    required String projectId,
    String? format,
  }) async {
    final uri = Uri.parse(
      '${ApiConstants.baseURL}'
      '${ApiConstants.projectEndPoint}'
      '$projectId/export',
    ).replace(
      queryParameters: {
        if (format != null) 'format': format,
      },
    );

    final response = await http.get(
      uri,
      headers: _headers(token),
    );

    if (response.statusCode != 200) {
      final json = _safeDecode(response);
      throw ApiException(
        json?['message'] ?? 'Export failed',
        statusCode: response.statusCode,
      );
    }

    return response.bodyBytes;
  }


  Future<ImportBackupResponse> importProject({
    required String token,
    required String projectId,
    required Uint8List fileBytes,
    required String fileName,
    String? format,
  }) async {
    final uri = Uri.parse(
      '${ApiConstants.baseURL}'
      '${ApiConstants.projectEndPoint}'
      '$projectId/import',
    ).replace(
      queryParameters: {
        if (format != null) 'format': format,
      },
    );

    final request = http.MultipartRequest('POST', uri);

    request.headers.addAll(_headers(token));

    request.files.add(
      http.MultipartFile.fromBytes(
        'file',
        fileBytes,
        filename: fileName,
      ),
    );

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    final json = _safeDecode(response);

    if (response.statusCode == 200) {
      return ImportBackupResponse.fromJson(json);
    }

    throw ApiException(
      json?['message'] ?? 'Import failed',
      statusCode: response.statusCode,
    );
  }


  dynamic _safeDecode(http.Response response) {
    if (response.body.isEmpty) return null;
    return jsonDecode(response.body);
  }
}