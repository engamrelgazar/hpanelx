abstract class AppException implements Exception {
  final String message;

  AppException(this.message);

  @override
  String toString() => message;
}

class TimeoutException extends AppException {
  TimeoutException(super.message);
}

class NetworkException extends AppException {
  NetworkException(super.message);
}

class ServerException extends AppException {
  ServerException(super.message);
}

class NotFoundException extends AppException {
  NotFoundException(super.message);
}

class UnauthorizedException extends AppException {
  UnauthorizedException(super.message);
}

class CancellationException extends AppException {
  CancellationException(super.message);
}

class UnexpectedException extends AppException {
  UnexpectedException(super.message);
}

class ValidationException extends AppException {
  ValidationException(super.message);
}

class CacheException extends AppException {
  CacheException(super.message);
}
