/// Base exception class for the application
abstract class AppException implements Exception {
  final String message;

  AppException(this.message);

  @override
  String toString() => message;
}

/// Exception thrown when a network request times out
class TimeoutException extends AppException {
  TimeoutException(String message) : super(message);
}

/// Exception thrown when a network error occurs
class NetworkException extends AppException {
  NetworkException(String message) : super(message);
}

/// Exception thrown when a server error occurs
class ServerException extends AppException {
  ServerException(String message) : super(message);
}

/// Exception thrown when a resource is not found
class NotFoundException extends AppException {
  NotFoundException(String message) : super(message);
}

/// Exception thrown when a user is not authorized to access a resource
class UnauthorizedException extends AppException {
  UnauthorizedException(String message) : super(message);
}

/// Exception thrown when a request is cancelled
class CancellationException extends AppException {
  CancellationException(String message) : super(message);
}

/// Exception thrown when an unexpected error occurs
class UnexpectedException extends AppException {
  UnexpectedException(String message) : super(message);
}

/// Exception thrown when a validation error occurs
class ValidationException extends AppException {
  ValidationException(String message) : super(message);
}

/// Exception thrown when a cache error occurs
class CacheException extends AppException {
  CacheException(String message) : super(message);
}
