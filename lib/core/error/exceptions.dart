class ServerException implements Exception {
  final String message;
  ServerException([this.message = 'Server Error']);
}

class CacheException implements Exception {}

class AuthException implements Exception {
  final String message;
  AuthException([this.message = 'Authentication Error']);
}

class NetworkException implements Exception {}
