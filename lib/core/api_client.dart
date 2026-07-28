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
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(LoggingInterceptor());
    _dio.interceptors.add(MockInterceptor(enableOfflineMock: true));
    _dio.interceptors.add(_apiKeyInterceptor());
    _dio.interceptors.add(_errorInterceptor());
  }

  InterceptorsWrapper _apiKeyInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        final key = await _getApiKey();
        if (key.isNotEmpty) {
          options.headers[ApiConfig.apiKeyHeader] = key;
        }
        handler.next(options);
      },
    );
  }

  InterceptorsWrapper _errorInterceptor() {
    return InterceptorsWrapper(
      onError: (error, handler) {
        switch (error.response?.statusCode) {
          case 401:
            return handler.reject(
              DioException(
                requestOptions: error.requestOptions,
                error: UnauthorizedException(data: error.response?.data),
              ),
            );
          case 403:
            return handler.reject(
              DioException(
                requestOptions: error.requestOptions,
                error: ForbiddenException(data: error.response?.data),
              ),
            );
          case 404:
            return handler.reject(
              DioException(
                requestOptions: error.requestOptions,
                error: NotFoundException(data: error.response?.data),
              ),
            );
          case 500:
            return handler.reject(
              DioException(
                requestOptions: error.requestOptions,
                error: ServerException(data: error.response?.data),
              ),
            );
          default:
            return handler.next(error);
        }
      },
    );
  }

  Future<String> _getApiKey() async {
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
