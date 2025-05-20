import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hpanelx/src/core/api/api_constants.dart';
import 'package:hpanelx/src/core/error/exceptions.dart';

/// A client for making API requests with proper error handling and authentication.
class ApiClient {
  final Dio _dio;
  static const String BEARER_TOKEN_KEY = 'BEARER_TOKEN';
  static String? _cachedToken;
  final Map<String, CancelToken> _cancelTokens = {};

  ApiClient() : _dio = Dio() {
    _configureOptions();
    _addInterceptors();
    _initialize();
  }

  /// Configures base Dio options
  void _configureOptions() {
    _dio.options.baseUrl = ApiConstants.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 15);
    _dio.options.receiveTimeout = const Duration(seconds: 15);
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  /// Adds interceptors for authentication and error handling
  void _addInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (_cachedToken == null) {
            // Try to read token from local storage if not in memory
            await _loadTokenFromStorage();
          }

          if (_cachedToken != null) {
            options.headers['Authorization'] = 'Bearer $_cachedToken';
          }

          return handler.next(options);
        },
        onError: (DioException error, handler) {
          // Log the error here if needed
          return handler.next(error);
        },
      ),
    );
  }

  /// Initialize the client by loading the token
  Future<void> _initialize() async {
    await _loadTokenFromStorage();
  }

  /// Loads the authentication token from local storage
  Future<void> _loadTokenFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _cachedToken = prefs.getString(BEARER_TOKEN_KEY);
    } catch (e) {
      // Handle storage access error
      _cachedToken = null;
    }
  }

  /// Updates the cached token
  void updateToken(String token) {
    _cachedToken = token;
  }

  /// Clears the cached token
  void clearToken() {
    _cachedToken = null;
  }

  /// Creates or returns an existing cancel token for a given request identifier
  CancelToken getCancelToken(String requestId) {
    if (!_cancelTokens.containsKey(requestId)) {
      _cancelTokens[requestId] = CancelToken();
    }
    return _cancelTokens[requestId]!;
  }

  /// Cancels a request with the specified identifier
  void cancelRequest(String requestId) {
    if (_cancelTokens.containsKey(requestId)) {
      _cancelTokens[requestId]!.cancel('Request cancelled');
      _cancelTokens.remove(requestId);
    }
  }

  /// Makes a GET request to the specified endpoint
  Future<dynamic> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    String? requestId,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        cancelToken: requestId != null ? getCancelToken(requestId) : null,
        options: headers != null ? Options(headers: headers) : null,
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw UnexpectedException('Unexpected error: ${e.toString()}');
    }
  }

  /// Makes a POST request to the specified endpoint
  Future<dynamic> post(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    String? requestId,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        cancelToken: requestId != null ? getCancelToken(requestId) : null,
        options: headers != null ? Options(headers: headers) : null,
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw UnexpectedException('Unexpected error: ${e.toString()}');
    }
  }

  /// Makes a PUT request to the specified endpoint
  Future<dynamic> put(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    String? requestId,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        cancelToken: requestId != null ? getCancelToken(requestId) : null,
        options: headers != null ? Options(headers: headers) : null,
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw UnexpectedException('Unexpected error: ${e.toString()}');
    }
  }

  /// Makes a DELETE request to the specified endpoint
  Future<dynamic> delete(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    String? requestId,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        cancelToken: requestId != null ? getCancelToken(requestId) : null,
        options: headers != null ? Options(headers: headers) : null,
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw UnexpectedException('Unexpected error: ${e.toString()}');
    }
  }

  /// Handles and translates Dio errors into application-specific exceptions
  Exception _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException(
            'Connection timed out. Please check your internet connection and try again.');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final data = error.response?.data;
        String message;

        if (data != null &&
            data is Map<String, dynamic> &&
            data.containsKey('message')) {
          message = data['message'];
        } else {
          message = error.message ?? 'Server error';
        }

        if (statusCode == 401) {
          return UnauthorizedException(
              'Unauthorized. Please check your API token and try again.');
        } else if (statusCode == 404) {
          return NotFoundException(
              'Resource not found. Please verify your request and try again.');
        } else if (statusCode == 500) {
          return ServerException(
              'Server error. Please try again later or contact support.');
        } else {
          return ServerException('Server error: $message');
        }
      case DioExceptionType.cancel:
        return CancellationException('Request cancelled');
      case DioExceptionType.connectionError:
        return NetworkException(
            'No internet connection. Please check your connection and try again.');
      default:
        return UnexpectedException(
            'Network error: ${error.message ?? "Unknown error"}');
    }
  }
}
