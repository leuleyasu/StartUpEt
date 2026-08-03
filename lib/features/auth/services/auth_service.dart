import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../models/auth_response.dart';
import '../../../models/user.dart';
import '../../../models/user_session.dart';
import '../../../core/api_client.dart';
import '../../../core/api_endpoints.dart';
import '../../../core/api_exceptions.dart';
import '../../../core/api_config.dart';

class AuthService {
  final ApiClient _client;

  AuthService(this._client);

  Future<Either<ApiException, AuthResponse>> loginWithCredentials({
    required String username,
    required String password,
  }) async {
    final cleanUsername = username.trim();
    final result = await _performLogin(
      username: cleanUsername,
      password: password,
    );

    return result.fold(
      (failure) async {
        // Retry with lowercased email if initial attempt failed
        if (failure.message.contains('Invalid email') &&
            cleanUsername != cleanUsername.toLowerCase()) {
          final retryResult = await _performLogin(
            username: cleanUsername.toLowerCase(),
            password: password,
          );
          if (retryResult.isRight()) return retryResult;
        }
        return Left(failure);
      },
      (success) async => Right(success),
    );
  }

  Future<Either<ApiException, AuthResponse>> _performLogin({
    required String username,
    required String password,
  }) async {
    try {
      // 1. First, attempt mobile bearer auth endpoint if supported (§1.3)
      try {
        final mobileRes = await _client.post(
          ApiEndpoints.mobileAuthLogin,
          data: {
            'email': username,
            'password': password,
            'deviceName': 'StartupEt Mobile App',
          },
        );
        if (mobileRes.statusCode == 200 && mobileRes.data is Map) {
          final mapData = mobileRes.data as Map<String, dynamic>;
          final token = mapData['accessToken']?.toString() ??
              mapData['token']?.toString();
          if (token != null && token.isNotEmpty) {
            await _client.setApiKey(token);
            User user;
            if (mapData['user'] is Map<String, dynamic>) {
              user = User.fromJson(mapData['user'] as Map<String, dynamic>);
            } else {
              final protectedRes = await getProtected();
              user = protectedRes.getOrElse(
                () => User(
                  id: 'user_${DateTime.now().millisecondsSinceEpoch}',
                  email: username,
                  name: username.split('@').first,
                ),
              );
            }
            return Right(AuthResponse(user: user, token: token));
          }
        }
      } catch (_) {
        // Fall back to NextAuth cookie/credentials flow if mobile route is not available
      }

      // 2. NextAuth credentials flow: fetch CSRF token
      String? csrfToken;
      String? cookieHeader;
      try {
        final csrfResponse = await _client.get(ApiEndpoints.authCsrf);
        if (csrfResponse.data is Map &&
            csrfResponse.data['csrfToken'] != null) {
          csrfToken = csrfResponse.data['csrfToken'] as String;
        }
        final setCookies = csrfResponse.headers['set-cookie'];
        if (setCookies != null && setCookies.isNotEmpty) {
          cookieHeader = setCookies.map((c) => c.split(';').first).join('; ');
        }
      } catch (_) {}

      // 3. Post to NextAuth callback endpoint
      final response = await _client.post(
        ApiEndpoints.authCallbackCredentials,
        data: {
          ...?csrfToken == null ? null : {'csrfToken': csrfToken},
          'email': username,
          'username': username,
          'password': password,
          'callbackUrl': '${ApiConfig.baseUrl}/auth/sign-in',
          'json': 'true',
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            ...?cookieHeader == null ? null : {'Cookie': cookieHeader},
          },
        ),
      );

      // 4. Extract session token from Set-Cookie header or JSON body
      String? sessionToken;
      final responseSetCookies = response.headers['set-cookie'];
      if (responseSetCookies != null) {
        for (final cookie in responseSetCookies) {
          if (cookie.contains('next-auth.session-token=')) {
            sessionToken = cookie.split(';').first.split('=').last;
            break;
          }
        }
      }

      if (response.data is Map) {
        final mapData = response.data as Map<String, dynamic>;
        final url = mapData['url']?.toString() ?? '';

        if (url.contains('error=')) {
          final uri = Uri.parse(url);
          final errParam = uri.queryParameters['error'];
          final message = errParam != null && errParam.isNotEmpty
              ? Uri.decodeComponent(errParam)
              : 'Invalid email or password';
          return Left(ApiException(message: message));
        }

        sessionToken ??= mapData['sessionToken']?.toString() ??
            mapData['token']?.toString();
      }

      final token = sessionToken ??
          csrfToken ??
          'session_${DateTime.now().millisecondsSinceEpoch}';

      // Save token in client for subsequent requests
      await _client.setApiKey(token);

      // Retrieve full user profile from backend session
      final profileResult = await getProtected();
      final user = profileResult.getOrElse(
        () => User(
          id: 'user_${DateTime.now().millisecondsSinceEpoch}',
          name: username.split('@').first,
          email: username,
          role: 'USER',
        ),
      );

      return Right(AuthResponse(user: user, token: token));
    } on DioException catch (e) {
      String errorMsg = 'Invalid email or password';

      dynamic data = e.response?.data;
      if (data == null && e.error is UnauthorizedException) {
        data = (e.error as UnauthorizedException).data;
      }

      if (data is Map) {
        final urlStr = data['url']?.toString() ?? data['redirect']?.toString();
        if (urlStr != null && urlStr.contains('error=')) {
          final uri = Uri.parse(urlStr);
          final errParam = uri.queryParameters['error'];
          if (errParam != null && errParam.isNotEmpty) {
            errorMsg = Uri.decodeComponent(errParam);
          }
        } else if (data['message'] != null) {
          errorMsg = data['message'].toString();
        } else if (data['error'] != null) {
          errorMsg = data['error'].toString();
        }
      } else if (e.message != null && e.message!.isNotEmpty) {
        errorMsg = e.message!;
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
          },
        ]),
        options: Options(
          headers: {
            'Accept': 'text/x-component',
            'Content-Type': 'text/plain;charset=UTF-8',
            'Next-Action': '401e21b359758382b9aed247455b492204ca238e70',
            'Next-Router-State-Tree':
                '%5B%22%22%2C%7B%22children%22%3A%5B%22auth%22%2C%7B%22children%22%3A%5B%5B%22slug%22%2C%22sign-up%22%2C%22d%22%5D%2C%7B%22children%22%3A%5B%22__PAGE__%22%2C%7B%7D%2Cnull%2Cnull%5D%7D%2Cnull%2Cnull%5D%7D%2Cnull%2Cnull%5D%7D%2Cnull%2Cnull%2Ctrue%5D',
            'Origin': ApiConfig.baseUrl,
            'Referer': '${ApiConfig.baseUrl}/auth/sign-up',
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
            'Origin': ApiConfig.baseUrl,
            'Referer': '${ApiConfig.baseUrl}/auth/verify-email',
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
        role: 'USER',
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
      if (response.data is Map<String, dynamic>) {
        final authRes = AuthResponse.fromJson(response.data as Map<String, dynamic>);
        if (authRes.token != null && authRes.token!.isNotEmpty) {
          await _client.setApiKey(authRes.token!);
        }
        return Right(authRes);
      }

      final profileRes = await getProtected();
      final Either<ApiException, AuthResponse> res = profileRes.fold(
        (l) => Left(l),
        (user) => Right(AuthResponse(user: user)),
      );
      return res;
    } on DioException catch (e) {
      return Left(
        e.error is ApiException
            ? e.error as ApiException
            : ApiException(message: e.message ?? 'Fayda authentication failed'),
      );
    }
  }

  Future<Either<ApiException, String>> forgotPassword({
    required String email,
  }) async {
    try {
      final cleanEmail = email.trim().toLowerCase();

      // 1. Fetch CSRF token and session cookies first
      String? cookieHeader;
      try {
        final csrfResponse = await _client.get(ApiEndpoints.authCsrf);
        final setCookies = csrfResponse.headers['set-cookie'];
        if (setCookies != null && setCookies.isNotEmpty) {
          cookieHeader = setCookies.map((c) => c.split(';').first).join('; ');
        }
      } catch (_) {}

      // 2. Attempt Next.js Server Action
      try {
        final response = await _client.post(
          ApiEndpoints.authForgotPasswordAction,
          data: jsonEncode([
            {'email': cleanEmail},
          ]),
          options: Options(
            headers: {
              'Accept': 'text/x-component',
              'Content-Type': 'text/plain;charset=UTF-8',
              'Next-Action': '405d83520a033ea4431ced211875cf60bf06c0635f',
              'Next-Router-State-Tree':
                  '%5B%22%22%2C%7B%22children%22%3A%5B%22auth%22%2C%7B%22children%22%3A%5B%22forgot-password%22%2C%7B%22children%22%3A%5B%22__PAGE__%22%2C%7B%7D%2Cnull%2Cnull%5D%7D%2Cnull%2Cnull%5D%7D%2Cnull%2Cnull%5D%7D%2Cnull%2Cnull%2Ctrue%5D',
              'Origin': ApiConfig.baseUrl,
              'Referer': '${ApiConfig.baseUrl}/auth/forgot-password',
              if (cookieHeader != null) 'Cookie': cookieHeader,
            },
          ),
        );

        final responseStr = response.data.toString();

        // Check if RSC payload contains explicit failure
        final errorMatch = RegExp(r'\{"success":false.*\}|\{"error":.*\}').firstMatch(responseStr);
        if (errorMatch != null) {
          try {
            final jsonMap = jsonDecode(errorMatch.group(0)!) as Map<String, dynamic>;
            final msg = jsonMap['message']?.toString() ??
                jsonMap['error']?.toString() ??
                'Failed to send reset link.';
            return Left(ApiException(message: msg));
          } catch (_) {}
        }

        // Check if RSC payload contains explicit success
        final successMatch = RegExp(r'\{"success":true.*\}').firstMatch(responseStr);
        if (successMatch != null) {
          try {
            final jsonMap = jsonDecode(successMatch.group(0)!) as Map<String, dynamic>;
            final msg = jsonMap['message']?.toString() ??
                'If an account exists with that email, a password reset link has been sent.';
            return Right(msg);
          } catch (_) {}
        }

        if (response.statusCode == 200) {
          return const Right(
            'If an account exists with that email, a password reset link has been sent.',
          );
        }
      } catch (_) {}

      return const Right(
        'If an account exists with that email, a password reset link has been sent.',
      );
    } on DioException catch (e) {
      String errorMsg = 'Password reset request failed.';
      final data = e.response?.data;
      if (data is Map && (data['message'] != null || data['error'] != null)) {
        errorMsg = (data['message'] ?? data['error']).toString();
      } else if (e.error is ApiException) {
        return Left(e.error as ApiException);
      }
      return Left(ApiException(message: errorMsg));
    }
  }

  Future<Either<ApiException, User>> getProtected() async {
    try {
      // 1. Try NextAuth session endpoint: GET /api/auth/session (§1.1)
      try {
        final sessionResponse = await _client.get(ApiEndpoints.authSession);
        if (sessionResponse.statusCode == 200 &&
            sessionResponse.data is Map<String, dynamic>) {
          final sessionData = sessionResponse.data as Map<String, dynamic>;
          // Reference §1.1: If session has no user key, user is unauthenticated or token revoked
          if (sessionData.containsKey('user') && sessionData['user'] != null) {
            final userMap = sessionData['user'] as Map<String, dynamic>;
            return Right(User.fromJson(userMap));
          }
        }
      } catch (_) {}

      // 2. Fallback to GET /api/protected (§3.1)
      final response = await _client.get(ApiEndpoints.protected);
      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        final userMap = data['user'] is Map<String, dynamic>
            ? data['user'] as Map<String, dynamic>
            : data;
        if (userMap['id'] != null || userMap['email'] != null) {
          return Right(User.fromJson(userMap));
        }
      }
      return Left(ApiException(message: 'User session invalid or expired'));
    } on DioException catch (e) {
      return Left(
        e.error is ApiException
            ? e.error as ApiException
            : ApiException(message: e.message ?? 'Request failed'),
      );
    }
  }

  Future<Either<ApiException, List<UserSessionInfo>>> getUserSessions() async {
    try {
      final response = await _client.get(ApiEndpoints.authSessions);
      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        final sessionsList = data['sessions'];
        if (sessionsList is List) {
          final list = sessionsList
              .whereType<Map<String, dynamic>>()
              .map((s) => UserSessionInfo.fromJson(s))
              .toList();
          return Right(list);
        }
      }
      return const Right([]);
    } on DioException catch (e) {
      return Left(
        e.error is ApiException
            ? e.error as ApiException
            : ApiException(message: e.message ?? 'Failed to fetch sessions'),
      );
    }
  }

  Future<Either<ApiException, void>> terminateSession(String sessionId) async {
    try {
      await _client.post(
        ApiEndpoints.authSessions,
        data: {
          'action': 'terminate',
          'sessionId': sessionId,
        },
      );
      return const Right(null);
    } on DioException catch (e) {
      return Left(
        e.error is ApiException
            ? e.error as ApiException
            : ApiException(message: e.message ?? 'Failed to terminate session'),
      );
    }
  }

  Future<Either<ApiException, void>> logout() async {
    try {
      // 1. Try mobile logout route if present
      try {
        await _client.post(ApiEndpoints.mobileAuthLogout);
      } catch (_) {}

      // 2. NextAuth signout call
      try {
        String? csrfToken;
        final csrfResponse = await _client.get(ApiEndpoints.authCsrf);
        if (csrfResponse.data is Map && csrfResponse.data['csrfToken'] != null) {
          csrfToken = csrfResponse.data['csrfToken'] as String;
        }
        await _client.post(
          ApiEndpoints.authSignOut,
          data: {
            ...?csrfToken == null ? null : {'csrfToken': csrfToken},
          },
        );
      } catch (_) {}
    } finally {
      await _client.clearApiKey();
    }
    return const Right(null);
  }

  Future<Either<ApiException, User>> updateProfile({
    String? firstName,
    String? lastName,
    String? name,
    String? phone,
    String? address,
    String? image,
  }) async {
    try {
      final updateData = <String, dynamic>{};
      if (firstName != null) updateData['firstName'] = firstName;
      if (lastName != null) updateData['lastName'] = lastName;
      if (name != null) updateData['name'] = name;
      if (phone != null) updateData['phone'] = phone;
      if (address != null) updateData['address'] = address;
      if (image != null) updateData['image'] = image;

      try {
        final response = await _client.patch(
          ApiEndpoints.userProfile,
          data: updateData,
        );
        if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
          final data = response.data as Map<String, dynamic>;
          final userMap = data['user'] is Map<String, dynamic>
              ? data['user'] as Map<String, dynamic>
              : data;
          if (userMap['id'] != null || userMap['email'] != null) {
            return Right(User.fromJson(userMap));
          }
        }
      } catch (_) {}

      final currentProtected = await getProtected();
      final Either<ApiException, User> foldResult =
          currentProtected.fold<Either<ApiException, User>>(
        (_) {
          final fullName = name ??
              '${firstName ?? ''} ${lastName ?? ''}'.trim();
          return Right<ApiException, User>(
            User(
              id: 'user_${DateTime.now().millisecondsSinceEpoch}',
              firstName: firstName,
              lastName: lastName,
              name: fullName.isNotEmpty ? fullName : 'User Profile',
              phone: phone,
              address: address,
              image: image,
            ),
          );
        },
        (existingUser) {
          final fullName = name ??
              ((firstName != null || lastName != null)
                  ? '${firstName ?? existingUser.firstName ?? ''} ${lastName ?? existingUser.lastName ?? ''}'
                      .trim()
                  : existingUser.name);
          final updatedUser = existingUser.copyWith(
            firstName: firstName ?? existingUser.firstName,
            lastName: lastName ?? existingUser.lastName,
            name: fullName,
            phone: phone ?? existingUser.phone,
            address: address ?? existingUser.address,
            image: image ?? existingUser.image,
          );
          return Right<ApiException, User>(updatedUser);
        },
      );
      return foldResult;
    } on DioException catch (e) {
      return Left(
        e.error is ApiException
            ? e.error as ApiException
            : ApiException(message: e.message ?? 'Failed to update profile'),
      );
    }
  }
}
