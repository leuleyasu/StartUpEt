import 'dart:convert';
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
        final url = mapData['url']?.toString() ?? '';
        if (url.contains('signin') || url.contains('error=')) {
          final uri = Uri.parse(url);
          final errParam = uri.queryParameters['error'];
          final message = errParam != null && errParam.isNotEmpty
              ? errParam
              : 'Invalid email or password';
          return Left(ApiException(message: message));
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
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String password,
    required String confirmPassword,
    required String role,
  }) async {
    try {
      final response = await _client.post(
        ApiEndpoints.authSignUpAction,
        data: jsonEncode([
          {
            'firstName': firstName,
            'lastName': lastName,
            'email': email,
            'phoneNumber': phoneNumber,
            'password': password,
            'confirmPassword': confirmPassword,
            'role': role,
          }
        ]),
        options: Options(
          headers: {
            'Accept': 'text/x-component',
            'Content-Type': 'text/plain;charset=UTF-8',
            'Next-Action': '401e21b359758382b9aed247455b492204ca238e70',
            'Next-Router-State-Tree':
                '%5B%22%22%2C%7B%22children%22%3A%5B%22auth%22%2C%7B%22children%22%3A%5B%5B%22slug%22%2C%22sign-up%22%2C%22d%22%5D%2C%7B%22children%22%3A%5B%22__PAGE__%22%2C%7B%7D%2Cnull%2Cnull%5D%7D%2Cnull%2Cnull%5D%7D%2Cnull%2Cnull%5D%7D%2Cnull%2Cnull%2Ctrue%5D',
          },
        ),
      );

      final responseStr = response.data.toString();

      if (responseStr.contains('"success":false')) {
        final match = RegExp(r'\{"success":false.*\}').firstMatch(responseStr);
        if (match != null) {
          final jsonMap = jsonDecode(match.group(0)!) as Map<String, dynamic>;
          return Left(
            ApiException(
              message: jsonMap['message']?.toString() ?? 'Registration failed',
            ),
          );
        }
      }

      if (responseStr.contains('"success":true')) {
        final match = RegExp(r'\{"success":true.*\}').firstMatch(responseStr);
        if (match != null) {
          final jsonMap = jsonDecode(match.group(0)!) as Map<String, dynamic>;
          final userJson = jsonMap['user'] as Map<String, dynamic>?;
          final message = jsonMap['message']?.toString();
          final user = User(
            id: userJson?['id']?.toString() ??
                'user_${DateTime.now().millisecondsSinceEpoch}',
            name: '$firstName $lastName',
            email: userJson?['email']?.toString() ?? email,
            phone: phoneNumber,
            role: role,
          );
          return Right(
            AuthResponse(
              user: user,
              token: 'token_${DateTime.now().millisecondsSinceEpoch}',
              requiresVerification: true,
              message: message ??
                  'Registration successful! Please check your email for the verification code.',
            ),
          );
        }
      }

      final user = User(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        name: '$firstName $lastName',
        email: email,
        phone: phoneNumber,
        role: role,
      );
      return Right(
        AuthResponse(
          user: user,
          token: 'token_${DateTime.now().millisecondsSinceEpoch}',
          requiresVerification: true,
          message:
              'Registration successful! Please check your email for the verification code.',
        ),
      );
    } on DioException catch (e) {
      return Left(
        e.error is ApiException
            ? e.error as ApiException
            : ApiException(message: e.message ?? 'Registration failed'),
      );
    }
  }

  Future<Either<ApiException, AuthResponse>> verifyCode({
    required String email,
    required String code,
  }) async {
    try {
      final cleanCode = code.trim();
      if (cleanCode.length < 6) {
        return Left(
          ApiException(
            message: 'Please enter a valid 6-digit verification code.',
          ),
        );
      }

      final response = await _client.post(
        ApiEndpoints.authVerifyEmailAction(email),
        data: jsonEncode([cleanCode]),
        options: Options(
          headers: {
            'Accept': 'text/x-component',
            'Content-Type': 'text/plain;charset=UTF-8',
            'Next-Action': '40b291a02f9702249b6363f8c05629181374779315',
            'Next-Router-State-Tree':
                '%5B%22%22%2C%7B%22children%22%3A%5B%22auth%22%2C%7B%22children%22%3A%5B%22verify-email%22%2C%7B%22children%22%3A%5B%22__PAGE__%22%2C%7B%7D%2Cnull%2Cnull%5D%7D%2Cnull%2Cnull%5D%7D%2Cnull%2Cnull%5D%7D%2Cnull%2Cnull%2Ctrue%5D',
          },
        ),
      );

      final responseStr = response.data.toString();

      if (responseStr.contains('"success":false')) {
        final match = RegExp(r'\{"success":false.*\}').firstMatch(responseStr);
        if (match != null) {
          final jsonMap = jsonDecode(match.group(0)!) as Map<String, dynamic>;
          return Left(
            ApiException(
              message: jsonMap['message']?.toString() ??
                  'Invalid or expired verification code.',
            ),
          );
        }
      }

      final user = User(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        name: email.split('@').first,
        email: email,
        role: 'Startup Founder',
      );
      return Right(
        AuthResponse(
          user: user,
          token: 'session_${DateTime.now().millisecondsSinceEpoch}',
          message: 'Email verified successfully! You can now log in.',
        ),
      );
    } on DioException catch (e) {
      return Left(
        e.error is ApiException
            ? e.error as ApiException
            : ApiException(message: e.message ?? 'Verification failed'),
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
