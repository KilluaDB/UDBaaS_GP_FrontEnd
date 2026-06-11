import 'dart:typed_data';
import 'dart:html' as html;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';

import 'package:dbaas_project/features/settings/viewModel/user_provider.dart';
import 'package:dbaas_project/features/backup/data/api_service.dart/backup_api.dart';

import 'backup_states.dart';

class BackupCubit extends Cubit<BackupState> {
  final BackupApiService _dataSource;
  final UserProvider userProvider;

  BackupCubit({
    required this.userProvider,
    BackupApiService? dataSource,
  })  : _dataSource = dataSource ?? BackupApiService(),
        super(BackupInitial());

  String? get _token => userProvider.currentUser?.data?.accessToken;


  Future<void> exportProject({
    required String projectId,
    String? format,
  }) async {
    emit(ExportBackupLoading());

    if (_token == null) {
      emit(ExportBackupError("User not logged in"));
      return;
    }

    try {
      final Uint8List bytes = await _dataSource.exportProject(
        token: _token!,
        projectId: projectId,
        format: format,
      );

      final fileName =
          "backup_${DateTime.now().millisecondsSinceEpoch}.bin";

      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);

      html.AnchorElement(href: url)
        ..setAttribute("download", fileName)
        ..click();

      html.Url.revokeObjectUrl(url);

      emit(ExportBackupSuccess(fileName));
    } catch (e) {
      emit(ExportBackupError(e.toString()));
    }
  }

  Future<void> importProjectFromPicker({
    required String projectId,
    String? format,
  }) async {
    emit(ImportBackupLoading());

    if (_token == null) {
      emit(ImportBackupError("User not logged in"));
      return;
    }

    try {
              
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        withData: true, 
      );

      if (result == null || result.files.isEmpty) {
        emit(ImportBackupError("No file selected"));
        return;
      }

      final Uint8List? fileBytes = result.files.first.bytes;
      final String fileName = result.files.first.name;

      if (fileBytes == null) {
        emit(ImportBackupError("Invalid file"));
        return;
      }
 await Future.delayed(const Duration(seconds: 1));

      final response = await _dataSource.importProject(
        token: _token!,
        projectId: projectId,
        fileBytes: fileBytes,
        fileName: fileName,
        format: format,
      );

      emit(ImportBackupSuccess(response.message));
    } catch (e) {
      emit(ImportBackupError(e.toString()));
    }
  }
}