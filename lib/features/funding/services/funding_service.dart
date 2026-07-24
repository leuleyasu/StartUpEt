import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../models/funding.dart';
import '../../../models/funding_application.dart';
import '../../../core/api_client.dart';
import '../../../core/api_endpoints.dart';
import '../../../core/api_exceptions.dart';

class FundingService {
  final ApiClient _client;

  FundingService(this._client);

  Future<Either<ApiException, List<Funding>>> getFunding() async {
    try {
      final response = await _client.get(ApiEndpoints.funding);
      final data = response.data;
      final list = data is List ? data : (data['data'] as List? ?? []);
      return Right(
        list.map((e) => Funding.fromJson(e as Map<String, dynamic>)).toList(),
      );
    } on DioException catch (e) {
      return Left(_error(e));
    }
  }

  Future<Either<ApiException, Funding>> getFundingDetail(String id) async {
    try {
      final response = await _client.get(ApiEndpoints.fundingId(id));
      return Right(Funding.fromJson(response.data as Map<String, dynamic>));
    } on DioException catch (e) {
      return Left(_error(e));
    }
  }

  Future<Either<ApiException, FundingApplication>> applyForFunding(
    String id,
    Map<String, dynamic> application,
  ) async {
    try {
      final response = await _client.post(
        ApiEndpoints.fundingApply(id),
        data: application,
      );
      return Right(
        FundingApplication.fromJson(response.data as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      return Left(_error(e));
    }
  }

  Future<Either<ApiException, List<FundingApplication>>>
  getMyApplications() async {
    try {
      final response = await _client.get(ApiEndpoints.fundingMyApplications);
      final data = response.data;
      final list = data is List ? data : (data['data'] as List? ?? []);
      return Right(
        list
            .map((e) => FundingApplication.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } on DioException catch (e) {
      return Left(_error(e));
    }
  }

  Future<Either<ApiException, Funding>> saveFunding(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.post(ApiEndpoints.fundingSave, data: data);
      return Right(Funding.fromJson(response.data as Map<String, dynamic>));
    } on DioException catch (e) {
      return Left(_error(e));
    }
  }

  ApiException _error(DioException e) => e.error is ApiException
      ? e.error as ApiException
      : ApiException(message: e.message ?? 'Request failed');
}
