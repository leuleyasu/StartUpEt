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

  Future<Either<ApiException, List<Funding>>> getFunding({
    String? category,
    String? status,
    String? query,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (category != null && category.isNotEmpty) queryParams['category'] = category;
      if (status != null && status.isNotEmpty) queryParams['status'] = status;
      if (query != null && query.isNotEmpty) queryParams['q'] = query;

      final response = await _client.get(
        ApiEndpoints.funding,
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );
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
      final rawData = response.data;
      final map = rawData is Map<String, dynamic>
          ? (rawData['data'] is Map<String, dynamic>
              ? rawData['data'] as Map<String, dynamic>
              : rawData)
          : <String, dynamic>{};
      return Right(Funding.fromJson(map));
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
      final rawData = response.data;
      final map = rawData is Map<String, dynamic>
          ? (rawData['data'] is Map<String, dynamic>
              ? rawData['data'] as Map<String, dynamic>
              : rawData)
          : <String, dynamic>{};
      return Right(FundingApplication.fromJson(map));
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

  Future<Either<ApiException, bool>> saveFunding(
    dynamic dataOrId,
  ) async {
    try {
      final String oppId = dataOrId is Map
          ? (dataOrId['opportunityId'] ?? dataOrId['id'] ?? '').toString()
          : dataOrId.toString();

      final response = await _client.post(
        ApiEndpoints.fundingSave,
        data: {'opportunityId': oppId},
      );
      if (response.data is Map) {
        final map = response.data as Map;
        final isSaved = map['saved'] == true ||
            map['isSaved'] == true ||
            map['success'] == true;
        return Right(isSaved);
      }
      return const Right(true);
    } on DioException catch (e) {
      return Left(_error(e));
    }
  }

  ApiException _error(DioException e) => e.error is ApiException
      ? e.error as ApiException
      : ApiException(message: e.message ?? 'Request failed');
}
