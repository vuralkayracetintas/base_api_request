import 'dart:developer';

/// Singleton class to manage authentication tokens
class TokenManager {
  static final TokenManager _instance = TokenManager._internal();
  factory TokenManager() => _instance;
  TokenManager._internal();

  /// Static getter for accessing the singleton instance
  static TokenManager get instance => _instance;

  String? _accessToken;
  String? _refreshToken;

  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;

  void setTokens({String? accessToken, String? refreshToken}) {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    log('🔑 Tokens saved to TokenManager');
    log('   Access Token: ${_accessToken?.substring(0, 20)}...');
    log('   Refresh Token: ${_refreshToken?.substring(0, 20)}...');
  }

  void clearTokens() {
    _accessToken = null;
    _refreshToken = null;
    log('🗑️ Tokens cleared from TokenManager');
  }

  bool hasTokens() {
    return _accessToken != null && _refreshToken != null;
  }
}
