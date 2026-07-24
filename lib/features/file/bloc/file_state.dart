import 'package:equatable/equatable.dart';

import '../../../models/file_info.dart';

abstract class FileState extends Equatable {
  const FileState();

  @override
  List<Object?> get props => [];
}

class FileInitial extends FileState {
  const FileInitial();
}

class FileLoading extends FileState {
  const FileLoading();
}

class FileLoaded extends FileState {
  final FileInfo file;
  const FileLoaded(this.file);
  @override
  List<Object?> get props => [file];
}

class FileDownloaded extends FileState {
  final List<int> bytes;
  const FileDownloaded(this.bytes);
  @override
  List<Object?> get props => [bytes];
}

class FileUploaded extends FileState {
  final FileInfo file;
  const FileUploaded(this.file);
  @override
  List<Object?> get props => [file];
}

class FileDeleted extends FileState {
  const FileDeleted();
}

class FileError extends FileState {
  final String message;
  const FileError(this.message);
  @override
  List<Object?> get props => [message];
}
