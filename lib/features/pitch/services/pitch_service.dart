import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../models/pitch.dart';
import '../../../core/api_client.dart';
import '../../../core/api_endpoints.dart';
import '../../../core/api_exceptions.dart';

class PitchService {
  final ApiClient _client;

  PitchService(this._client);

  Future<Either<ApiException, Pitch>> createPitch(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.post(ApiEndpoints.pitches, data: data);
      return Right(Pitch.fromJson(response.data as Map<String, dynamic>));
    } on DioException catch (e) {
      return Left(_error(e));
    }
  }

  ApiException _error(DioException e) => e.error is ApiException
      ? e.error as ApiException
      : ApiException(message: e.message ?? 'Failed to create pitch');
}
