import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';
import '../models/user_model.dart';
import '../../../../core/error/exceptions.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(String name, String email, String password, String role);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await apiClient.post(
        ApiConstants.login,
        data: {
          'email': email,
          'password': password,
        },
      );
      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      } else {
        throw ServerException('Failed to login');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        throw AuthException('Invalid email or password');
      }
      throw ServerException(e.message ?? 'Unknown Error');
    }
  }

  @override
  Future<UserModel> register(String name, String email, String password, String role) async {
    try {
      final response = await apiClient.post(
        ApiConstants.register,
        data: {
          'name': name,
          'email': email,
          'password': password,
          'role': role,
        },
      );
      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      } else {
        throw ServerException('Failed to register');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw ServerException('Invalid registration details');
      }
      throw ServerException(e.message ?? 'Unknown Error');
    }
  }
}
