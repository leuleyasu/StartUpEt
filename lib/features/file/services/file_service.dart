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

  Future<Either<ApiException, void>> deleteFile(
    String id, {
    bool hard = false,
  }) async {
    try {
      await _client.delete(
        ApiEndpoints.file(id),
        queryParameters: hard ? {'hard': 'true'} : null,
      );
      return const Right(null);
    } on DioException catch (e) {
      return Left(_error(e));
    }
  }

  Future<Either<ApiException, List<int>>> downloadFile(
    String id, {
    bool inline = false,
  }) async {
    try {
      final response = await _client.get(
        ApiEndpoints.fileDownload(id),
        queryParameters: inline ? {'inline': 'true'} : null,
        options: Options(responseType: ResponseType.bytes),
      );
      return Right(List<int>.from(response.data as List));
    } on DioException catch (e) {
      return Left(_error(e));
    }
  }

  Future<Either<ApiException, FileInfo>> uploadFile(
    String filePath, {
    FileCategory category = FileCategory.other,
    String? categoryString,
    bool isPublic = false,
    String? entityType,
    String? entityId,
    String? directory,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final catValue = categoryString ?? category.value;
      final map = <String, dynamic>{
        'file': await MultipartFile.fromFile(filePath),
        'category': catValue,
        'isPublic': isPublic ? 'true' : 'false',
      };
      if (entityType != null) map['entityType'] = entityType;
      if (entityId != null) map['entityId'] = entityId;
      if (directory != null) map['directory'] = directory;
      if (metadata != null) map['metadata'] = metadata;

      final formData = FormData.fromMap(map);
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

  Future<Either<ApiException, String>> uploadAvatar(String filePath) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath),
      });
      final response = await _client.post(
        ApiEndpoints.uploadAvatar,
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );
      final data = response.data;
      if (data is Map && data['url'] != null) {
        return Right(data['url'].toString());
      }
      return Left(ApiException(message: 'Failed to retrieve uploaded avatar URL'));
    } on DioException catch (e) {
      return Left(_error(e));
    }
  }

  ApiException _error(DioException e) => e.error is ApiException
      ? e.error as ApiException
      : ApiException(message: e.message ?? 'Request failed');
}
