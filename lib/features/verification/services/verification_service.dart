import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../models/verification_result.dart';
import '../../../core/api_client.dart';
import '../../../core/api_endpoints.dart';
import '../../../core/api_exceptions.dart';

class VerificationService {
  final ApiClient _client;

  VerificationService(this._client);

  Future<Either<ApiException, VerificationResult>> verifyNationalId(
    String nationalId,
  ) async {
    try {
      final response = await _client.get(
        ApiEndpoints.verifyNationalId,
        queryParameters: {'fcn': nationalId.trim()},
      );
      return Right(
        VerificationResult.fromJson(response.data as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      return Left(_error(e));
    }
  }

  Future<Either<ApiException, VerificationResult>> verifyTin(String tin) async {
    try {
      final response = await _client.get(
        ApiEndpoints.verifyTin,
        queryParameters: {'tin': tin.trim()},
      );
      return Right(
        VerificationResult.fromJson(response.data as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      return Left(_error(e));
    }
  }

  ApiException _error(DioException e) => e.error is ApiException
      ? e.error as ApiException
      : ApiException(message: e.message ?? 'Verification failed');
}
