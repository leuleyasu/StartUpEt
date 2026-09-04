import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/file_service.dart';
import 'file_event.dart';
import 'file_state.dart';

class FileBloc extends Bloc<FileEvent, FileState> {
  final FileService _service;

  FileBloc(this._service) : super(const FileInitial()) {
    on<FetchFile>(_onFetch);
    on<DownloadFile>(_onDownload);
    on<UploadFile>(_onUpload);
    on<DeleteFile>(_onDelete);
  }

  Future<void> _onFetch(FetchFile event, Emitter<FileState> emit) async {
    emit(const FileLoading());
    final r = await _service.getFile(event.id);
    r.fold((f) => emit(FileError(f.message)), (d) => emit(FileLoaded(d)));
  }

  Future<void> _onDownload(DownloadFile event, Emitter<FileState> emit) async {
    emit(const FileLoading());
    final r = await _service.downloadFile(event.id);
    r.fold((f) => emit(FileError(f.message)), (d) => emit(FileDownloaded(d)));
  }

  Future<void> _onUpload(UploadFile event, Emitter<FileState> emit) async {
    emit(const FileLoading());
    final r = await _service.uploadFile(
      event.filePath,
      category: event.category,
      categoryString: event.categoryString,
      isPublic: event.isPublic,
      entityType: event.entityType,
      entityId: event.entityId,
      directory: event.directory,
      metadata: event.metadata,
    );
    r.fold((f) => emit(FileError(f.message)), (d) => emit(FileUploaded(d)));
  }

  Future<void> _onDelete(DeleteFile event, Emitter<FileState> emit) async {
    emit(const FileLoading());
    final r = await _service.deleteFile(event.id);
    r.fold((f) => emit(FileError(f.message)), (_) => emit(const FileDeleted()));
  }
}
