import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../models/notification_info.dart';
import '../../../core/api_client.dart';
import '../../../core/api_endpoints.dart';
import '../../../core/api_exceptions.dart';

class NotificationService {
  final ApiClient _client;

  NotificationService(this._client);

  Future<Either<ApiException, NotificationInfo>> streamNotifications() async {
    try {
      final response = await _client.get(
        ApiEndpoints.notificationsStream,
        options: Options(responseType: ResponseType.stream),
      );
      return Right(
        NotificationInfo.fromJson(response.data as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      return Left(_error(e));
    }
  }

  ApiException _error(DioException e) => e.error is ApiException
      ? e.error as ApiException
      : ApiException(message: e.message ?? 'Stream failed');
}
