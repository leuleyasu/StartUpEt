import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../models/cron_result.dart';
import '../../../core/api_client.dart';
import '../../../core/api_endpoints.dart';
import '../../../core/api_exceptions.dart';

class CronService {
  final ApiClient _client;

  CronService(this._client);

  Future<Either<ApiException, CronResult>> checkExpirations() async {
    try {
      final response = await _client.get(ApiEndpoints.cronCheckExpirations);
      return Right(CronResult.fromJson(response.data as Map<String, dynamic>));
    } on DioException catch (e) {
      return Left(_error(e));
    }
  }

  ApiException _error(DioException e) => e.error is ApiException
      ? e.error as ApiException
      : ApiException(message: e.message ?? 'Cron check failed');
}
