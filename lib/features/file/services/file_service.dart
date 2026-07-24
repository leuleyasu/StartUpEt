import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../models/file_info.dart';
import '../../../core/api_client.dart';
import '../../../core/api_endpoints.dart';
import '../../../core/api_exceptions.dart';

class FileService {
  final ApiClient _client;

  FileService(this._client);

  Future<Either<ApiException, FileInfo>> getFile(String id) async {
    try {
      final response = await _client.get(ApiEndpoints.file(id));
      return Right(FileInfo.fromJson(response.data as Map<String, dynamic>));
    } on DioException catch (e) {
      return Left(_error(e));
    }
  }

  Future<Either<ApiException, FileInfo>> updateFile(
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.patch(ApiEndpoints.file(id), data: data);
      return Right(FileInfo.fromJson(response.data as Map<String, dynamic>));
    } on DioException catch (e) {
      return Left(_error(e));
    }
  }

  Future<Either<ApiException, void>> deleteFile(String id) async {
    try {
      await _client.delete(ApiEndpoints.file(id));
      return const Right(null);
    } on DioException catch (e) {
      return Left(_error(e));
    }
  }

  Future<Either<ApiException, List<int>>> downloadFile(String id) async {
    try {
      final response = await _client.get(
        ApiEndpoints.fileDownload(id),
        options: Options(responseType: ResponseType.bytes),
      );
      return Right(List<int>.from(response.data as List));
    } on DioException catch (e) {
      return Left(_error(e));
    }
  }

  Future<Either<ApiException, FileInfo>> uploadFile(String filePath) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath),
      });
      final response = await _client.post(
        ApiEndpoints.fileUpload,
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );
      return Right(FileInfo.fromJson(response.data as Map<String, dynamic>));
    } on DioException catch (e) {
      return Left(_error(e));
    }
  }

  ApiException _error(DioException e) => e.error is ApiException
      ? e.error as ApiException
      : ApiException(message: e.message ?? 'Request failed');
}
