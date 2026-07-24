import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../models/booking.dart';
import '../../../models/ecosystem_application.dart';
import '../../../models/ecosystem_event.dart';
import '../../../models/event_attendee.dart';
import '../../../models/funding.dart';
import '../../../models/funding_application.dart';
import '../../../models/investment_pitch.dart';
import '../../../models/investment_profile.dart';
import '../../../models/news.dart';
import '../../../models/space.dart';
import '../../../core/api_client.dart';
import '../../../core/api_endpoints.dart';
import '../../../core/api_exceptions.dart';

class EcosystemService {
  final ApiClient _client;

  EcosystemService(this._client);

  List<T> _parseList<T>(
    dynamic data,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final list = data is List ? data : (data['data'] as List? ?? []);
    return list.map((e) => fromJson(e as Map<String, dynamic>)).toList();
  }

  T _parseSingle<T>(dynamic data, T Function(Map<String, dynamic>) fromJson) =>
      fromJson(data as Map<String, dynamic>);

  Future<Either<ApiException, List<EcosystemApplication>>>
  getApplications() async {
    try {
      final response = await _client.get(ApiEndpoints.ecosystemApplication);
      return Right(_parseList(response.data, EcosystemApplication.fromJson));
    } on DioException catch (e) {
      return Left(_error(e));
    }
  }

  Future<Either<ApiException, EcosystemApplication>> getApplication(
    String id,
  ) async {
    try {
      final response = await _client.get(
        ApiEndpoints.ecosystemApplicationId(id),
      );
      return Right(_parseSingle(response.data, EcosystemApplication.fromJson));
    } on DioException catch (e) {
      return Left(_error(e));
    }
  }

  Future<Either<ApiException, List<EcosystemApplication>>> apply({
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final response = await _client.get(
        ApiEndpoints.ecosystemApply,
        queryParameters: queryParams,
      );
      return Right(_parseList(response.data, EcosystemApplication.fromJson));
    } on DioException catch (e) {
      return Left(_error(e));
    }
  }

  Future<Either<ApiException, EcosystemApplication>> submitApplication(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.post(
        ApiEndpoints.ecosystemApply,
        data: data,
      );
      return Right(_parseSingle(response.data, EcosystemApplication.fromJson));
    } on DioException catch (e) {
      return Left(_error(e));
    }
  }

  Future<Either<ApiException, List<Space>>> getSpaces() async {
    try {
      final response = await _client.get(ApiEndpoints.ecosystemSpaces);
      return Right(_parseList(response.data, Space.fromJson));
    } on DioException catch (e) {
      return Left(_error(e));
    }
  }

  Future<Either<ApiException, Space>> createSpace(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.post(
        ApiEndpoints.ecosystemSpaces,
        data: data,
      );
      return Right(_parseSingle(response.data, Space.fromJson));
    } on DioException catch (e) {
      return Left(_error(e));
    }
  }

  Future<Either<ApiException, Space>> updateSpace(
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.put(
        ApiEndpoints.ecosystemSpace(id),
        data: data,
      );
      return Right(_parseSingle(response.data, Space.fromJson));
    } on DioException catch (e) {
      return Left(_error(e));
    }
  }

  Future<Either<ApiException, void>> deleteSpace(String id) async {
    try {
      await _client.delete(ApiEndpoints.ecosystemSpace(id));
      return const Right(null);
    } on DioException catch (e) {
      return Left(_error(e));
    }
  }

  Future<Either<ApiException, List<EcosystemEvent>>> getEvents() async {
    try {
      final response = await _client.get(ApiEndpoints.ecosystemEvents);
      return Right(_parseList(response.data, EcosystemEvent.fromJson));
    } on DioException catch (e) {
      return Left(_error(e));
    }
  }

  Future<Either<ApiException, EcosystemEvent>> getEvent(String id) async {
    try {
      final response = await _client.get(ApiEndpoints.ecosystemEvent(id));
      return Right(_parseSingle(response.data, EcosystemEvent.fromJson));
    } on DioException catch (e) {
      return Left(_error(e));
    }
  }

  Future<Either<ApiException, EcosystemEvent>> createEvent(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.post(
        ApiEndpoints.ecosystemEvents,
        data: data,
      );
      return Right(_parseSingle(response.data, EcosystemEvent.fromJson));
    } on DioException catch (e) {
      return Left(_error(e));
    }
  }

  Future<Either<ApiException, EcosystemEvent>> updateEvent(
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.put(
        ApiEndpoints.ecosystemEvent(id),
        data: data,
      );
      return Right(_parseSingle(response.data, EcosystemEvent.fromJson));
    } on DioException catch (e) {
      return Left(_error(e));
    }
  }

  Future<Either<ApiException, void>> deleteEvent(String id) async {
    try {
      await _client.delete(ApiEndpoints.ecosystemEvent(id));
      return const Right(null);
    } on DioException catch (e) {
      return Left(_error(e));
    }
  }

  Future<Either<ApiException, List<EventAttendee>>> getEventAttendees(
    String id,
  ) async {
    try {
      final response = await _client.get(
        ApiEndpoints.ecosystemEventAttendees(id),
      );
      return Right(_parseList(response.data, EventAttendee.fromJson));
    } on DioException catch (e) {
      return Left(_error(e));
    }
  }

  Future<Either<ApiException, EventAttendee>> addEventAttendee(
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.post(
        ApiEndpoints.ecosystemEventAttendees(id),
        data: data,
      );
      return Right(_parseSingle(response.data, EventAttendee.fromJson));
    } on DioException catch (e) {
      return Left(_error(e));
    }
  }

  Future<Either<ApiException, EventAttendee>> updateEventAttendee(
    String id,
    String attendeeId,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.put(
        ApiEndpoints.ecosystemEventAttendee(id, attendeeId),
        data: data,
      );
      return Right(_parseSingle(response.data, EventAttendee.fromJson));
    } on DioException catch (e) {
      return Left(_error(e));
    }
  }

  Future<Either<ApiException, void>> removeEventAttendee(
    String id,
    String attendeeId,
  ) async {
    try {
      await _client.delete(ApiEndpoints.ecosystemEventAttendee(id, attendeeId));
      return const Right(null);
    } on DioException catch (e) {
      return Left(_error(e));
    }
  }

  Future<Either<ApiException, List<Funding>>> getFunding() async {
    try {
      final response = await _client.get(ApiEndpoints.ecosystemFunding);
      return Right(_parseList(response.data, Funding.fromJson));
    } on DioException catch (e) {
      return Left(_error(e));
    }
  }

  Future<Either<ApiException, Funding>> getFundingById(String id) async {
    try {
      final response = await _client.get(ApiEndpoints.ecosystemFundingId(id));
      return Right(_parseSingle(response.data, Funding.fromJson));
    } on DioException catch (e) {
      return Left(_error(e));
    }
  }

  Future<Either<ApiException, Funding>> updateFunding(
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.put(
        ApiEndpoints.ecosystemFundingId(id),
        data: data,
      );
      return Right(_parseSingle(response.data, Funding.fromJson));
    } on DioException catch (e) {
      return Left(_error(e));
    }
  }

  Future<Either<ApiException, void>> deleteFunding(String id) async {
    try {
      await _client.delete(ApiEndpoints.ecosystemFundingId(id));
      return const Right(null);
    } on DioException catch (e) {
      return Left(_error(e));
    }
  }

  Future<Either<ApiException, List<FundingApplication>>>
  getFundingApplications() async {
    try {
      final response = await _client.get(
        ApiEndpoints.ecosystemFundingApplications,
      );
      return Right(_parseList(response.data, FundingApplication.fromJson));
    } on DioException catch (e) {
      return Left(_error(e));
    }
  }

  Future<Either<ApiException, FundingApplication>> updateFundingApplication(
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.put(
        ApiEndpoints.ecosystemFundingApplication(id),
        data: data,
      );
      return Right(_parseSingle(response.data, FundingApplication.fromJson));
    } on DioException catch (e) {
      return Left(_error(e));
    }
  }

  Future<Either<ApiException, List<InvestmentPitch>>>
  getInvestmentsPitches() async {
    try {
      final response = await _client.get(
        ApiEndpoints.ecosystemInvestmentsPitches,
      );
      return Right(_parseList(response.data, InvestmentPitch.fromJson));
    } on DioException catch (e) {
      return Left(_error(e));
    }
  }

  Future<Either<ApiException, InvestmentProfile>>
  getInvestmentsProfile() async {
    try {
      final response = await _client.get(
        ApiEndpoints.ecosystemInvestmentsProfile,
      );
      return Right(_parseSingle(response.data, InvestmentProfile.fromJson));
    } on DioException catch (e) {
      return Left(_error(e));
    }
  }

  Future<Either<ApiException, InvestmentProfile>> updateInvestmentsProfile(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.post(
        ApiEndpoints.ecosystemInvestmentsProfile,
        data: data,
      );
      return Right(_parseSingle(response.data, InvestmentProfile.fromJson));
    } on DioException catch (e) {
      return Left(_error(e));
    }
  }

  Future<Either<ApiException, List<News>>> getNews() async {
    try {
      final response = await _client.get(ApiEndpoints.ecosystemNews);
      return Right(_parseList(response.data, News.fromJson));
    } on DioException catch (e) {
      return Left(_error(e));
    }
  }

  Future<Either<ApiException, News>> getNewsById(String id) async {
    try {
      final response = await _client.get(ApiEndpoints.ecosystemNewsId(id));
      return Right(_parseSingle(response.data, News.fromJson));
    } on DioException catch (e) {
      return Left(_error(e));
    }
  }

  Future<Either<ApiException, News>> createNews(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.post(
        ApiEndpoints.ecosystemNews,
        data: data,
      );
      return Right(_parseSingle(response.data, News.fromJson));
    } on DioException catch (e) {
      return Left(_error(e));
    }
  }

  Future<Either<ApiException, News>> updateNews(
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.put(
        ApiEndpoints.ecosystemNewsId(id),
        data: data,
      );
      return Right(_parseSingle(response.data, News.fromJson));
    } on DioException catch (e) {
      return Left(_error(e));
    }
  }

  Future<Either<ApiException, void>> deleteNews(String id) async {
    try {
      await _client.delete(ApiEndpoints.ecosystemNewsId(id));
      return const Right(null);
    } on DioException catch (e) {
      return Left(_error(e));
    }
  }

  Future<Either<ApiException, List<Booking>>> getBookings() async {
    try {
      final response = await _client.get(ApiEndpoints.ecosystemBookings);
      return Right(_parseList(response.data, Booking.fromJson));
    } on DioException catch (e) {
      return Left(_error(e));
    }
  }

  Future<Either<ApiException, Booking>> createBooking(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.post(
        ApiEndpoints.ecosystemBookings,
        data: data,
      );
      return Right(_parseSingle(response.data, Booking.fromJson));
    } on DioException catch (e) {
      return Left(_error(e));
    }
  }

  Future<Either<ApiException, Booking>> updateBooking(
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.put(
        ApiEndpoints.ecosystemBooking(id),
        data: data,
      );
      return Right(_parseSingle(response.data, Booking.fromJson));
    } on DioException catch (e) {
      return Left(_error(e));
    }
  }

  Future<Either<ApiException, void>> deleteBooking(String id) async {
    try {
      await _client.delete(ApiEndpoints.ecosystemBooking(id));
      return const Right(null);
    } on DioException catch (e) {
      return Left(_error(e));
    }
  }

  ApiException _error(DioException e) => e.error is ApiException
      ? e.error as ApiException
      : ApiException(message: e.message ?? 'Request failed');
}
