import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../models/ecosystem_event.dart';
import '../../../models/event_registration.dart';
import '../../../core/api_client.dart';
import '../../../core/api_endpoints.dart';
import '../../../core/api_exceptions.dart';

class EventService {
  final ApiClient _client;

  EventService(this._client);

  Future<Either<ApiException, List<EcosystemEvent>>> getEvents() async {
    try {
      final response = await _client.get(ApiEndpoints.events);
      final data = response.data;
      final list = data is List ? data : (data['data'] as List? ?? []);
      return Right(
        list
            .map((e) => EcosystemEvent.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } on DioException catch (e) {
      return Left(_error(e));
    }
  }

  Future<Either<ApiException, EcosystemEvent>> getEvent(String id) async {
    try {
      final response = await _client.get(ApiEndpoints.event(id));
      return Right(
        EcosystemEvent.fromJson(response.data as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      return Left(_error(e));
    }
  }

  Future<Either<ApiException, EventRegistration>> registerForEvent(
    String id,
    Map<String, dynamic> registrationData,
  ) async {
    try {
      final response = await _client.post(
        ApiEndpoints.eventRegister(id),
        data: registrationData,
      );
      return Right(
        EventRegistration.fromJson(response.data as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      return Left(_error(e));
    }
  }

  Future<Either<ApiException, List<EventRegistration>>>
  getMyRegistrations() async {
    try {
      final response = await _client.get(ApiEndpoints.eventMyRegistrations);
      final data = response.data;
      final list = data is List ? data : (data['data'] as List? ?? []);
      return Right(
        list
            .map((e) => EventRegistration.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } on DioException catch (e) {
      return Left(_error(e));
    }
  }

  ApiException _error(DioException e) => e.error is ApiException
      ? e.error as ApiException
      : ApiException(message: e.message ?? 'Request failed');
}
