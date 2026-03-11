import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/app_constants.dart';

class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage secureStorage;

  AuthInterceptor(this.secureStorage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Exclude login and register from requiring a token
    if (!options.path.contains('/auth/login') && !options.path.contains('/auth/register')) {
      final token = await secureStorage.read(key: AppConstants.tokenKey);
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Optionally handle 401 globally here to log out user
    return handler.next(err);
  }
}
