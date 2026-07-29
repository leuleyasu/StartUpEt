import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'api_config.dart';
import 'api_exceptions.dart';
import 'logging_interceptor.dart';
import 'mock_interceptor.dart';

class ApiClient {
  late final Dio _dio;
  final FlutterSecureStorage _secureStorage;

  ApiClient(this._secureStorage) {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: ApiConfig.connectTimeout,
        receiveTimeout: ApiConfig.receiveTimeout,
        followRedirects: true,
        validateStatus: (status) => status != null && status < 500,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(LoggingInterceptor());
    _dio.interceptors.add(MockInterceptor(enableOfflineMock: false));
    _dio.interceptors.add(_authInterceptor());
    _dio.interceptors.add(_errorInterceptor());
  }

  InterceptorsWrapper _authInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        final key = await getToken();
        if (key.isNotEmpty) {
          options.headers[ApiConfig.apiKeyHeader] = key;
          options.headers['Authorization'] = 'Bearer $key';

          // Standard NextAuth cookie headers so getServerSession pick it up seamlessly
          final existingCookie = options.headers['Cookie']?.toString() ?? '';
          if (!existingCookie.contains('next-auth.session-token')) {
            final sessionCookie =
                'next-auth.session-token=$key; __Secure-next-auth.session-token=$key';
            options.headers['Cookie'] = existingCookie.isEmpty
                ? sessionCookie
                : '$existingCookie; $sessionCookie';
          }
        }
        handler.next(options);
      },
    );
  }

  InterceptorsWrapper _errorInterceptor() {
    return InterceptorsWrapper(
      onError: (error, handler) async {
        final statusCode = error.response?.statusCode;
        if (statusCode == 401) {
          // If token was revoked or invalid, clear token from storage
          await clearApiKey();
          return handler.reject(
            DioException(
              requestOptions: error.requestOptions,
              error: UnauthorizedException(data: error.response?.data),
            ),
          );
        } else if (statusCode == 403) {
          return handler.reject(
            DioException(
              requestOptions: error.requestOptions,
              error: ForbiddenException(data: error.response?.data),
            ),
          );
        } else if (statusCode == 404) {
          return handler.reject(
            DioException(
              requestOptions: error.requestOptions,
              error: NotFoundException(data: error.response?.data),
            ),
          );
        } else if (statusCode == 500) {
          return handler.reject(
            DioException(
              requestOptions: error.requestOptions,
              error: ServerException(data: error.response?.data),
            ),
          );
        }
        return handler.next(error);
      },
    );
  }

  Future<String> getToken() async {
    final stored = await _secureStorage.read(key: 'api_key');
    if (stored != null && stored.isNotEmpty) return stored;
    if (ApiConfig.defaultApiKey.isNotEmpty) {
      await _secureStorage.write(
        key: 'api_key',
        value: ApiConfig.defaultApiKey,
      );
      return ApiConfig.defaultApiKey;
    }
    return '';
  }

  Future<void> setApiKey(String key) async {
    await _secureStorage.write(key: 'api_key', value: key);
  }

  Future<void> clearApiKey() async {
    await _secureStorage.delete(key: 'api_key');
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _dio.get(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _dio.patch(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }
}
