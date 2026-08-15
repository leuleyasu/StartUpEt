import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../models/report.dart';
import '../../../core/api_client.dart';
import '../../../core/api_endpoints.dart';
import '../../../core/api_exceptions.dart';

class ReportService {
  final ApiClient _client;

  ReportService(this._client);

  Future<Either<ApiException, ReportSubmissionResult>> submitReport({
    required ReportType reportType,
    String? notes,
    List<String> fileIds = const [],
  }) async {
    try {
      final response = await _client.post(
        ApiEndpoints.reportsSubmit,
        data: {
          'reportType': reportType.value,
          if (notes != null) 'notes': notes,
          'fileIds': fileIds,
        },
      );
      final rawData = response.data;
      if (rawData is Map<String, dynamic>) {
        return Right(ReportSubmissionResult.fromJson(rawData));
      }
      return const Right(ReportSubmissionResult(success: true));
    } on DioException catch (e) {
      return Left(_error(e));
    }
  }

  Future<Either<ApiException, List<HubReport>>> getHubReports() async {
    try {
      final response = await _client.get(ApiEndpoints.hubReports);
      final data = response.data;
      final list = data is List ? data : (data['data'] as List? ?? []);
      return Right(
        list.map((e) => HubReport.fromJson(e as Map<String, dynamic>)).toList(),
      );
    } on DioException catch (e) {
      return Left(_error(e));
    }
  }

  Future<Either<ApiException, HubReport>> submitHubReport({
    required String hubId,
    required String period,
    required String title,
    String? description,
    Map<String, dynamic>? metrics,
  }) async {
    try {
      final response = await _client.post(
        ApiEndpoints.hubReports,
        data: {
          'hubId': hubId,
          'period': period,
          'title': title,
          if (description != null) 'description': description,
          if (metrics != null) 'metrics': metrics,
        },
      );
      final rawData = response.data;
      final map = rawData is Map<String, dynamic>
          ? (rawData['data'] is Map<String, dynamic>
              ? rawData['data'] as Map<String, dynamic>
              : rawData)
          : <String, dynamic>{};
      return Right(HubReport.fromJson(map));
    } on DioException catch (e) {
      return Left(_error(e));
    }
  }

  ApiException _error(DioException e) => e.error is ApiException
      ? e.error as ApiException
      : ApiException(message: e.message ?? 'Report operation failed');
}
