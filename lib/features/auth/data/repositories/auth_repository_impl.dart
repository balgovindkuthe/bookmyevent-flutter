import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final FlutterSecureStorage secureStorage;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.secureStorage,
  });

  @override
  Future<Either<Failure, UserEntity>> login(String email, String password) async {
    try {
      final userModel = await remoteDataSource.login(email, password);
      await _cacheUserData(userModel);
      return Right(userModel);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register(String name, String email, String password, String role) async {
    try {
      final userModel = await remoteDataSource.register(name, email, password, role);
      await _cacheUserData(userModel);
      return Right(userModel);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await secureStorage.deleteAll();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to clear local data.'));
    }
  }

  @override
  Future<Either<Failure, bool>> checkLoggedInStatus() async {
    try {
      final token = await secureStorage.read(key: AppConstants.tokenKey);
      return Right(token != null);
    } catch (e) {
      return Left(CacheFailure('Failed to read local data.'));
    }
  }

  Future<void> _cacheUserData(UserEntity user) async {
    await secureStorage.write(key: AppConstants.tokenKey, value: user.token);
    await secureStorage.write(key: AppConstants.userIdKey, value: user.id.toString());
    await secureStorage.write(key: AppConstants.userRoleKey, value: user.role);
    await secureStorage.write(key: AppConstants.userNameKey, value: user.name);
    await secureStorage.write(key: AppConstants.userEmailKey, value: user.email);
  }
}
