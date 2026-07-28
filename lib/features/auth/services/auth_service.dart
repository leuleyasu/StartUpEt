import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../models/auth_response.dart';
import '../../../models/user.dart';
import '../../../core/api_client.dart';
import '../../../core/api_endpoints.dart';
import '../../../core/api_exceptions.dart';

class AuthService {
  final ApiClient _client;

  AuthService(this._client);

  Future<Either<ApiException, AuthResponse>> loginWithCredentials({
    required String username,
    required String password,
  }) async {
    try {
      // 1. Get NextAuth CSRF token
      String? csrfToken;
      try {
        final csrfResponse = await _client.get(ApiEndpoints.authCsrf);
        if (csrfResponse.data is Map && csrfResponse.data['csrfToken'] != null) {
          csrfToken = csrfResponse.data['csrfToken'] as String;
        }
      } catch (_) {}

      // 2. Post to NextAuth callback endpoint with json=true query parameter
      final response = await _client.post(
        '${ApiEndpoints.authCallbackCredentials}?json=true',
        data: {
          if (csrfToken != null) 'csrfToken': csrfToken,
          'email': username,
          'username': username,
          'password': password,
          'json': 'true',
        },
      );

      if (response.data is Map) {
        final mapData = response.data as Map<String, dynamic>;
        if (mapData.containsKey('url') && mapData['url'].toString().contains('error=')) {
          final uri = Uri.parse(mapData['url'].toString());
          final errParam = uri.queryParameters['error'];
          return Left(ApiException(message: errParam ?? 'Invalid email or password'));
        }
        return Right(AuthResponse.fromJson(mapData));
      }

      return Right(
        AuthResponse.fromJson(response.data as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      String errorMsg = e.message ?? 'Login failed';
      if (e.error is UnauthorizedException) {
        final data = (e.error as UnauthorizedException).data;
        if (data is Map && data['url'] != null) {
          final uri = Uri.parse(data['url'].toString());
          final errParam = uri.queryParameters['error'];
          if (errParam != null && errParam.isNotEmpty) {
            errorMsg = errParam;
          }
        } else {
          errorMsg = 'Invalid email or password';
        }
      }
      return Left(ApiException(message: errorMsg));
    }
  }

  Future<Either<ApiException, AuthResponse>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.post(
        ApiEndpoints.authRegister,
        data: {
          'name': name,
          'email': email,
          'password': password,
        },
      );
      return Right(
        AuthResponse.fromJson(response.data as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      return Left(
        e.error is ApiException
            ? e.error as ApiException
            : ApiException(message: e.message ?? 'Registration failed'),
      );
    }
  }

  Future<Either<ApiException, AuthResponse>> loginWithFayda(
    String authCode,
  ) async {
    try {
      final response = await _client.get(
        ApiEndpoints.authCallbackFayda,
        queryParameters: {'code': authCode},
      );
      return Right(
        AuthResponse.fromJson(response.data as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      return Left(
        e.error is ApiException
            ? e.error as ApiException
            : ApiException(message: e.message ?? 'Login failed'),
      );
    }
  }

  Future<Either<ApiException, User>> getProtected() async {
    try {
      final response = await _client.get(ApiEndpoints.protected);
      return Right(User.fromJson(response.data as Map<String, dynamic>));
    } on DioException catch (e) {
      return Left(
        e.error is ApiException
            ? e.error as ApiException
            : ApiException(message: e.message ?? 'Request failed'),
      );
    }
  }
}
