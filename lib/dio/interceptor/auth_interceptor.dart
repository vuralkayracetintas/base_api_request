import 'dart:developer';

import 'package:base_apis/dio/token_manager.dart';
import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  final TokenManager tokenManager;

  AuthInterceptor({required this.tokenManager});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = tokenManager.accessToken;
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
      log('🔐 Auth header added: Bearer ${token.substring(0, 20)}...');
    } else {
      log('⚠️ No access token available in TokenManager');
    }
    handler.next(options);
  }
}
