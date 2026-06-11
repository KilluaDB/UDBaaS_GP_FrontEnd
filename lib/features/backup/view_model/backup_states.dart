abstract class BackupState {}

class BackupInitial extends BackupState {}

// EXPORT
class ExportBackupLoading extends BackupState {}
class ExportBackupSuccess extends BackupState {
  final String filePath;
  ExportBackupSuccess(this.filePath);
}
class ExportBackupError extends BackupState {
  final String message;
  ExportBackupError(this.message);
}

// IMPORT
class ImportBackupLoading extends BackupState {}
class ImportBackupSuccess extends BackupState {
  final String message;
  ImportBackupSuccess(this.message);
}
class ImportBackupError extends BackupState {
  final String message;
  ImportBackupError(this.message);
}