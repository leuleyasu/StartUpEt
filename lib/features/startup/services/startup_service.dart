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
      final rawData = response.data;
      if (rawData == null || rawData is! Map<String, dynamic>) {
        return Left(ApiException(message: 'Invalid startup status payload'));
      }
      return Right(StartupStatus.fromJson(rawData));
    } on DioException catch (e) {
      return Left(
        e.error is ApiException
            ? e.error as ApiException
            : ApiException(message: e.message ?? 'Failed to fetch status'),
      );
    } catch (e) {
      return Left(ApiException(message: 'Error parsing startup status: $e'));
    }
  }

  Future<Either<ApiException, StartupStatus>> renew() async {
    try {
      final response = await _client.post(ApiEndpoints.startupRenew);
      final rawData = response.data;
      if (rawData == null || rawData is! Map<String, dynamic>) {
        return Left(ApiException(message: 'Invalid renewal status payload'));
      }
      return Right(StartupStatus.fromJson(rawData));
    } on DioException catch (e) {
      return Left(
        e.error is ApiException
            ? e.error as ApiException
            : ApiException(message: e.message ?? 'Renewal failed'),
      );
    } catch (e) {
      return Left(ApiException(message: 'Error parsing renewal status: $e'));
    }
  }
}
