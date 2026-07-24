import 'package:equatable/equatable.dart';

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

  const UploadFile(this.filePath);

  @override
  List<Object?> get props => [filePath];
}

class DeleteFile extends FileEvent {
  final String id;

  const DeleteFile(this.id);

  @override
  List<Object?> get props => [id];
}
