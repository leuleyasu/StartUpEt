class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  const ApiException({required this.message, this.statusCode, this.data});

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class UnauthorizedException extends ApiException {
  const UnauthorizedException({super.message = 'Unauthorized', super.data})
    : super(statusCode: 401);
}

class ForbiddenException extends ApiException {
  const ForbiddenException({super.message = 'Forbidden', super.data})
    : super(statusCode: 403);
}

class NotFoundException extends ApiException {
  const NotFoundException({super.message = 'Not found', super.data})
    : super(statusCode: 404);
}

class ServerException extends ApiException {
  const ServerException({super.message = 'Server error', super.data})
    : super(statusCode: 500);
}

class NetworkException extends ApiException {
  const NetworkException({super.message = 'Network error'})
    : super(statusCode: null);
}
