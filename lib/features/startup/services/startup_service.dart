import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../models/startup_status.dart';
import '../../../core/api_client.dart';
import '../../../core/api_endpoints.dart';
import '../../../core/api_exceptions.dart';

class StartupService {
  final ApiClient _client;

  StartupService(this._client);

  Future<Either<ApiException, StartupStatus>> getMyStatus() async {
    try {
      final response = await _client.get(ApiEndpoints.startupMyStatus);
      return Right(
        StartupStatus.fromJson(response.data as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      return Left(
        e.error is ApiException
            ? e.error as ApiException
            : ApiException(message: e.message ?? 'Failed to fetch status'),
      );
    }
  }

  Future<Either<ApiException, StartupStatus>> renew() async {
    try {
      final response = await _client.post(ApiEndpoints.startupRenew);
      return Right(
        StartupStatus.fromJson(response.data as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      return Left(
        e.error is ApiException
            ? e.error as ApiException
            : ApiException(message: e.message ?? 'Renewal failed'),
      );
    }
  }
}
