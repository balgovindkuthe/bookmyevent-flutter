import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../datasources/analytics_remote_datasource.dart';
import '../../domain/entities/analytics_entity.dart';
import '../../domain/repositories/analytics_repository.dart';

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final AnalyticsRemoteDataSource remoteDataSource;

  AnalyticsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, AnalyticsEntity>> getEventAnalytics(int eventId) async {
    try {
      final analytics = await remoteDataSource.getEventAnalytics(eventId);
      return Right(analytics);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
