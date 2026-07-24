import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../models/certificate.dart';
import '../../../core/api_client.dart';
import '../../../core/api_endpoints.dart';
import '../../../core/api_exceptions.dart';

class CertificateService {
  final ApiClient _client;

  CertificateService(this._client);

  Future<Either<ApiException, List<int>>> downloadCertificate(String id) async {
    try {
      final response = await _client.get(
        ApiEndpoints.certificateDownload(id),
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
    String id,
  ) async {
    try {
      final response = await _client.get(
        ApiEndpoints.certificateDownloadAlt(id),
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

  Future<Either<ApiException, Certificate>> generatePdf(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.post(
        ApiEndpoints.certificateGeneratePdf,
        data: data,
      );
      return Right(Certificate.fromJson(response.data as Map<String, dynamic>));
    } on DioException catch (e) {
      return Left(
        e.error is ApiException
            ? e.error as ApiException
            : ApiException(message: e.message ?? 'PDF generation failed'),
      );
    }
  }
}
