import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hpanelx/src/core/api/api_constants.dart';

class ApiClient {
  final Dio _dio;
  static const String BEARER_TOKEN_KEY = 'BEARER_TOKEN';
  static String? _cachedToken;

  ApiClient() : _dio = Dio() {
    _dio.options.baseUrl = ApiConstants.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // Log interceptor
    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true, error: true),
    );

    // Auth interceptor - automatically adds token to each request
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
      ),
    );

    // Load token at startup
    _initialize();
  }

  Future<void> _initialize() async {
    await _loadTokenFromStorage();
  }

  Future<void> _loadTokenFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    _cachedToken = prefs.getString(BEARER_TOKEN_KEY);
  }

  // GET request
  Future<dynamic> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  // POST request
  Future<dynamic> post(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  // PUT request
  Future<dynamic> put(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  // DELETE request
  Future<dynamic> delete(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  // Error handling
  dynamic _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw Exception('Connection timed out');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final data = error.response?.data;
        if (statusCode == 401) {
          throw Exception('Unauthorized');
        } else if (statusCode == 404) {
          throw Exception('Resource not found');
        } else {
          throw Exception('Server error: ${data['message'] ?? error.message}');
        }
      case DioExceptionType.cancel:
        throw Exception('Request cancelled');
      case DioExceptionType.connectionError:
        throw Exception('No internet connection');
      default:
        throw Exception('Network error: ${error.message}');
    }
  }
}
