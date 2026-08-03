import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../models/application.dart';
import '../../../core/api_client.dart';
import '../../../core/api_endpoints.dart';
import '../../../core/api_exceptions.dart';

class ApplicationService {
  final ApiClient _client;

  ApplicationService(this._client);

  Future<Either<ApiException, List<Application>>> getApplications({
    int page = 1,
    int pageSize = 20,
    String tab = 'all',
  }) async {
    try {
      final response = await _client.get(
        ApiEndpoints.applications,
        queryParameters: {'page': page, 'pageSize': pageSize, 'tab': tab},
      );
      final data = response.data;
      final list = data is List ? data : (data['data'] as List? ?? []);
      return Right(
        list
            .map((e) => Application.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } on DioException catch (e) {
      return Left(_error(e));
    }
  }

  Future<Either<ApiException, Application>> getApplication(String id) async {
    try {
      final response = await _client.get(ApiEndpoints.application(id));
      return Right(Application.fromJson(response.data as Map<String, dynamic>));
    } on DioException catch (e) {
      return Left(_error(e));
    }
  }

  Future<Either<ApiException, Application>> createApplication(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.post(
        ApiEndpoints.applications,
        data: data,
      );
      final resData = response.data;
      final map = resData is Map<String, dynamic>
          ? (resData['data'] is Map<String, dynamic>
                ? resData['data'] as Map<String, dynamic>
                : resData)
          : <String, dynamic>{};
      return Right(Application.fromJson(map));
    } on DioException catch (e) {
      return Left(_error(e));
    }
  }

  Future<Either<ApiException, Application>> updateApplication(
    Map<String, dynamic> data,
  ) async {
    try {
      final id = data['id'];
      final endpoint = id != null
          ? ApiEndpoints.application(id.toString())
          : ApiEndpoints.applications;
      final response = await _client.patch(endpoint, data: data);
      final resData = response.data;
      final map = resData is Map<String, dynamic>
          ? (resData['data'] is Map<String, dynamic>
                ? resData['data'] as Map<String, dynamic>
                : resData)
          : <String, dynamic>{};
      return Right(Application.fromJson(map));
    } on DioException catch (e) {
      return Left(_error(e));
    }
  }

  ApiException _error(DioException e) => e.error is ApiException
      ? e.error as ApiException
      : ApiException(message: e.message ?? 'Request failed');
}
