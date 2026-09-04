import 'package:equatable/equatable.dart';

import '../../../models/file_info.dart';

abstract class FileEvent extends Equatable {
  const FileEvent();

  @override
  List<Object?> get props => [];
}

class FetchFile extends FileEvent {
  final String id;

  const FetchFile(this.id);

  @override
  List<Object?> get props => [id];
}

class DownloadFile extends FileEvent {
  final String id;

  const DownloadFile(this.id);

  @override
  List<Object?> get props => [id];
}

class UploadFile extends FileEvent {
  final String filePath;
  final FileCategory category;
  final String? categoryString;
  final bool isPublic;
  final String? entityType;
  final String? entityId;
  final String? directory;
  final Map<String, dynamic>? metadata;

  const UploadFile(
    this.filePath, {
    this.category = FileCategory.other,
    this.categoryString,
    this.isPublic = false,
    this.entityType,
    this.entityId,
    this.directory,
    this.metadata,
  });

  @override
  List<Object?> get props => [
        filePath,
        category,
        categoryString,
        isPublic,
        entityType,
        entityId,
        directory,
        metadata,
      ];
}

class DeleteFile extends FileEvent {
  final String id;

  const DeleteFile(this.id);

  @override
  List<Object?> get props => [id];
}
