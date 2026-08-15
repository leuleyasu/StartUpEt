import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../core/api_client.dart';
import '../../../core/api_endpoints.dart';
import '../../../core/api_exceptions.dart';

class CertificateService {
  final ApiClient _client;

  CertificateService(this._client);

  Future<Either<ApiException, List<int>>> downloadCertificate(
    String id, {
    bool inline = false,
  }) async {
    try {
      final response = await _client.get(
        ApiEndpoints.certificateDownload(id),
        queryParameters: inline ? {'inline': 'true'} : null,
        options: Options(responseType: ResponseType.bytes),
      );
      return Right(List<int>.from(response.data as List));
    } on DioException catch (e) {
      return Left(
        e.error is ApiException
            ? e.error as ApiException
            : ApiException(message: e.message ?? 'Download failed'),
      );
    }
  }

  Future<Either<ApiException, List<int>>> downloadCertificateAlt(
    String id, {
    bool inline = false,
  }) async {
    try {
      final response = await _client.get(
        ApiEndpoints.certificateDownloadAlt(id),
        queryParameters: inline ? {'inline': 'true'} : null,
        options: Options(responseType: ResponseType.bytes),
      );
      return Right(List<int>.from(response.data as List));
    } on DioException catch (e) {
      return Left(
        e.error is ApiException
            ? e.error as ApiException
            : ApiException(message: e.message ?? 'Download failed'),
      );
    }
  }

  Future<Either<ApiException, List<int>>> generatePdf(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.post(
        ApiEndpoints.certificateGeneratePdf,
        data: data,
        options: Options(responseType: ResponseType.bytes),
      );
      return Right(List<int>.from(response.data as List));
    } on DioException catch (e) {
      return Left(
        e.error is ApiException
            ? e.error as ApiException
            : ApiException(message: e.message ?? 'PDF generation failed'),
      );
    }
  }
}
