import 'dart:developer';
import 'package:base_apis/dio/api_error_model.dart';
import 'package:base_apis/dio/api_response_model.dart';
import 'package:base_apis/dio/interceptor/auth_interceptor.dart';
import 'package:base_apis/dio/interceptor/error_logging_interceptor.dart';
import 'package:base_apis/dio/interceptor/refresh_token_interceptor.dart';
import 'package:base_apis/dio/interceptor/retry_interceptor.dart';
import 'package:base_apis/dio/token_manager.dart';
import 'package:dio/dio.dart';

class DioApiManager {
  static DioApiManager? _instance;
  final Dio _dio;
  final Function()? onTokenExpired;

  DioApiManager._internal({required String baseUrl, this.onTokenExpired})
    : _dio = Dio(BaseOptions(baseUrl: baseUrl)) {
    _dio.interceptors.addAll([
      LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        responseHeader: true,
        requestHeader: true,
      ),
      AuthInterceptor(tokenManager: TokenManager.instance),
      RefreshTokenInterceptor(
        dio: _dio,
        baseUrl: baseUrl,
        onTokenExpired: onTokenExpired,
      ),
      RetryInterceptor(dio: _dio),
      ErrorLoggingInterceptor(),
    ]);
  }

  factory DioApiManager({
    required String baseUrl,
    String? token,
    Function()? onTokenExpired,
  }) {
    _instance ??= DioApiManager._internal(
      baseUrl: baseUrl,
      onTokenExpired: onTokenExpired,
    );
    return _instance!;
  }

  static void resetInstance() {
    _instance = null;
  }

  /// GET request for any model type
  Future<ApiResponseModel<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParams,
    Options? options,
    Map<String, dynamic>? data,
    T Function(dynamic data)? converter,
  }) async {
    return _request<T>(
      _dio.get(
        endpoint,
        queryParameters: queryParams,
        options: options,
        data: data,
      ),
      converter: converter,
      endpoint: endpoint,
    );
  }

  /// POST request for any model type
  Future<ApiResponseModel<T>> post<T>(
    String endpoint, {
    Map<String, dynamic>? data,
    Options? options,
    T Function(dynamic data)? converter,
  }) async {
    return _request<T>(
      _dio.post(endpoint, data: data, options: options),
      converter: converter,
      endpoint: endpoint,
    );
  }

  /// PUT request for any model type
  Future<ApiResponseModel<T>> put<T>(
    String endpoint, {
    Map<String, dynamic>? data,
    Options? options,
    T Function(dynamic data)? converter,
  }) async {
    return _request<T>(
      _dio.put(endpoint, data: data, options: options),
      converter: converter,
      endpoint: endpoint,
    );
  }

  /// DELETE request for any model type
  Future<ApiResponseModel<T>> delete<T>(
    String endpoint, {
    Map<String, dynamic>? queryParams,
    Options? options,
    T Function(dynamic data)? converter,
  }) async {
    return _request<T>(
      _dio.delete(endpoint, queryParameters: queryParams, options: options),
      converter: converter,
      endpoint: endpoint,
    );
  }

  /// Centralized request handling with model conversion
  Future<ApiResponseModel<T>> _request<T>(
    Future<Response> request, {
    T Function(dynamic data)? converter,
    required String endpoint,
  }) async {
    try {
      final response = await request;
      // await check("${Config.apiBaseUrl}$endpoint", _dio);
      if (converter != null) {
        final T model = converter(response.data);
        return ApiResponseModel.success(model);
      } else {
        return ApiResponseModel.success(response.data);
      }
    } on DioException catch (e) {
      log("DioException: ${e.message}");
      return ApiResponseModel.error(_handleDioError(e));
    } catch (e) {
      log("Unexpected Error: $e");
      return ApiResponseModel.error(
        ApiErrorModel(message: "Unexpected error occurred."),
      );
    }
  }

  /// Handle DioError and map to ApiError
  ApiErrorModel _handleDioError(DioException e) {
    if (e.response != null) {
      switch (e.response?.statusCode) {
        case 400:
          return ApiErrorModel(
            message: "Bad request. Please check your data.",
            statusCode: e.response?.statusCode,
          );
        case 401:
          return ApiErrorModel(
            message: "Unauthorized. Please login again.",
            statusCode: e.response?.statusCode,
          );
        case 404:
          return ApiErrorModel(
            message: "Resource not found.",
            statusCode: e.response?.statusCode,
          );
        case 500:
          return ApiErrorModel(
            message: "Internal server error. Please try again later.",
            statusCode: e.response?.statusCode,
          );
        default:
          return ApiErrorModel(
            message: "Error: ${e.response?.statusMessage}",
            statusCode: e.response?.statusCode,
          );
      }
    } else if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return ApiErrorModel(
        message: "Connection timed out. Please check your internet.",
      );
    } else if (e.message != null && e.message!.contains('SocketException')) {
      return ApiErrorModel(
        message: "No internet connection. Please try again.",
      );
    } else {
      return ApiErrorModel(message: "Unexpected error occurred.");
    }
  }
}
