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
      if (response.statusCode != null && response.statusCode! >= 400) {
        return Left(_extractError(response));
      }
      final data = response.data;
      if (data is Map && data.containsKey('error')) {
        return Left(ApiException(message: data['error'].toString(), statusCode: response.statusCode));
      }
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
      if (response.statusCode != null && response.statusCode! >= 400) {
        return Left(_extractError(response));
      }
      final data = response.data;
      if (data is Map && data.containsKey('error')) {
        return Left(ApiException(message: data['error'].toString(), statusCode: response.statusCode));
      }
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
      if (response.statusCode != null && response.statusCode! >= 400) {
        return Left(_extractError(response));
      }
      final resData = response.data;
      if (resData is Map && resData.containsKey('error')) {
        return Left(ApiException(message: resData['error'].toString(), statusCode: response.statusCode));
      }
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
      if (response.statusCode != null && response.statusCode! >= 400) {
        return Left(_extractError(response));
      }
      final resData = response.data;
      if (resData is Map && resData.containsKey('error')) {
        return Left(ApiException(message: resData['error'].toString(), statusCode: response.statusCode));
      }
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

  ApiException _extractError(Response response) {
    String message = 'Request failed';
    if (response.data is Map) {
      final map = response.data as Map;
      if (map['error'] != null) {
        message = map['error'].toString();
      } else if (map['message'] != null) {
        message = map['message'].toString();
      }
    }
    return ApiException(message: message, statusCode: response.statusCode);
  }

  ApiException _error(DioException e) {
    if (e.error is ApiException) {
      return e.error as ApiException;
    }
    String message = e.message ?? 'Request failed';
    if (e.response?.data is Map) {
      final resData = e.response!.data as Map;
      if (resData['error'] != null) {
        message = resData['error'].toString();
      } else if (resData['message'] != null) {
        message = resData['message'].toString();
      }
    }
    return ApiException(message: message, statusCode: e.response?.statusCode);
  }
}
