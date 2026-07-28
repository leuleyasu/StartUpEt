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
      final response = await _client.post(
        ApiEndpoints.authCallbackCredentials,
        data: {
          'username': username,
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
            : ApiException(message: e.message ?? 'Login failed'),
      );
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
