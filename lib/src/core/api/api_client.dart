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
      throw _handleError(e);
    } catch (e) {
      throw Exception('Unexpected error: ${e.toString()}');
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
      throw _handleError(e);
    } catch (e) {
      throw Exception('Unexpected error: ${e.toString()}');
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
      throw _handleError(e);
    } catch (e) {
      throw Exception('Unexpected error: ${e.toString()}');
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
      throw _handleError(e);
    } catch (e) {
      throw Exception('Unexpected error: ${e.toString()}');
    }
  }

  // Error handling
  Exception _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception(
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
          return Exception(
              'Unauthorized. Please check your API token and try again.');
        } else if (statusCode == 404) {
          return Exception(
              'Resource not found. Please verify your request and try again.');
        } else if (statusCode == 500) {
          return Exception(
              'Server error. Please try again later or contact support.');
        } else {
          return Exception('Server error: $message');
        }
      case DioExceptionType.cancel:
        return Exception('Request cancelled');
      case DioExceptionType.connectionError:
        return Exception(
            'No internet connection. Please check your connection and try again.');
      default:
        return Exception('Network error: ${error.message ?? "Unknown error"}');
    }
  }
}
