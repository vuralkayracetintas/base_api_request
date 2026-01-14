import 'dart:developer';
import 'package:base_apis/dio/token_manager.dart';
import 'package:base_apis/model/token_response_model.dart';
import 'package:dio/dio.dart';

class RefreshTokenInterceptor extends Interceptor {
  final Dio dio;
  final String baseUrl;
  final Function()? onTokenExpired;

  RefreshTokenInterceptor({
    required this.dio,
    required this.baseUrl,
    this.onTokenExpired,
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Check if error is 401 and not from refresh endpoint
    if (err.response?.statusCode == 401 &&
        !err.requestOptions.path.contains('auth/refresh')) {
      log('Token expired, attempting to refresh...');

      final tokenManager = TokenManager();
      final refreshToken = tokenManager.refreshToken;

      if (refreshToken == null) {
        log('No refresh token available, redirecting to login');
        onTokenExpired?.call();
        return handler.next(err);
      }

      try {
        // Attempt to refresh the token
        final response = await _refreshToken(refreshToken);

        if (response != null) {
          // Update tokens
          tokenManager.setTokens(
            accessToken: response.accessToken,
            refreshToken: response.refreshToken,
          );

          log('Token refreshed successfully, retrying original request');

          // Retry the original request with new token
          final requestOptions = err.requestOptions;
          requestOptions.headers['Authorization'] =
              'Bearer ${response.accessToken}';

          try {
            final retryResponse = await dio.fetch(requestOptions);
            return handler.resolve(retryResponse);
          } catch (e) {
            log('Failed to retry request after refresh: $e');
            return handler.next(err);
          }
        } else {
          log('Failed to refresh token, redirecting to login');
          tokenManager.clearTokens();
          onTokenExpired?.call();
          return handler.next(err);
        }
      } catch (e) {
        log('Error during token refresh: $e');
        tokenManager.clearTokens();
        onTokenExpired?.call();
        return handler.next(err);
      }
    }

    return handler.next(err);
  }

  Future<TokenResponseModel?> _refreshToken(String refreshToken) async {
    try {
      final cleanBaseUrl = baseUrl.endsWith('/')
          ? baseUrl.substring(0, baseUrl.length - 1)
          : baseUrl;
      final response = await dio.post(
        '$cleanBaseUrl/auth/refresh',
        data: {'refreshToken': refreshToken, 'expiresInMins': 2},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        return TokenResponseModel.fromJson(response.data);
      }
      return null;
    } catch (e) {
      log('Failed to refresh token: $e');
      return null;
    }
  }
}
