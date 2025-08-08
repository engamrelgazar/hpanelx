import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hpanelx/src/core/api/api_constants.dart';
import 'package:hpanelx/src/core/error/exceptions.dart';
import 'dart:io';

class ApiClient {
  final Dio _dio;
  final SharedPreferences _sharedPreferences;
  static const String BEARER_TOKEN_KEY = 'BEARER_TOKEN';
  static String? _cachedToken;
  final Map<String, CancelToken> _cancelTokens = {};

  ApiClient({required SharedPreferences sharedPreferences})
      : _dio = Dio(),
        _sharedPreferences = sharedPreferences {
    _configureOptions();
    _addInterceptors();
    _initialize();
  }

  void _configureOptions() {
    _dio.options.baseUrl = ApiConstants.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 15);
    _dio.options.receiveTimeout = const Duration(seconds: 15);
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  void _addInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (_cachedToken == null) {
            _loadTokenFromStorage();
          }

          if (_cachedToken != null) {
            options.headers['Authorization'] = 'Bearer $_cachedToken';
          }

          return handler.next(options);
        },
        onError: (DioException error, handler) {
          return handler.next(error);
        },
      ),
    );
  }

  void _initialize() {
    _loadTokenFromStorage();
  }

  void _loadTokenFromStorage() {
    try {
      _cachedToken = _sharedPreferences.getString(BEARER_TOKEN_KEY);
    } catch (e) {
      _cachedToken = null;
    }
  }

  void updateToken(String token) {
    _cachedToken = token;

    _sharedPreferences.setString(BEARER_TOKEN_KEY, token);
  }

  void clearToken() {
    _cachedToken = null;

    _sharedPreferences.remove(BEARER_TOKEN_KEY);
  }

  CancelToken getCancelToken(String requestId) {
    if (!_cancelTokens.containsKey(requestId)) {
      _cancelTokens[requestId] = CancelToken();
    }
    return _cancelTokens[requestId]!;
  }

  void cancelRequest(String requestId) {
    if (_cancelTokens.containsKey(requestId)) {
      _cancelTokens[requestId]!.cancel('Request cancelled');
      _cancelTokens.remove(requestId);
    }
  }

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
      throw await _handleError(e);
    } catch (e) {
      throw UnexpectedException('Unexpected error: ${e.toString()}');
    }
  }

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
      throw await _handleError(e);
    } catch (e) {
      throw UnexpectedException('Unexpected error: ${e.toString()}');
    }
  }

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
      throw await _handleError(e);
    } catch (e) {
      throw UnexpectedException('Unexpected error: ${e.toString()}');
    }
  }

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
      throw await _handleError(e);
    } catch (e) {
      throw UnexpectedException('Unexpected error: ${e.toString()}');
    }
  }

  Future<bool> _hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  Future<Exception> _handleError(DioException error) async {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        final hasInternet = await _hasInternetConnection();
        if (!hasInternet) {
          return NetworkException(
              'No internet connection. Please check your connection and try again.');
        }
        return TimeoutException(
            'Connection timed out. The server may be unavailable. Please try again later.');
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
        final hasInternet = await _hasInternetConnection();
        if (!hasInternet) {
          return NetworkException(
              'No internet connection. Please check your connection and try again.');
        }
        return ServerException(
            'Unable to connect to the server. The server may be down or unreachable. Please try again later.');
      default:
        return UnexpectedException(
            'Network error: ${error.message ?? "Unknown error"}');
    }
  }
}
