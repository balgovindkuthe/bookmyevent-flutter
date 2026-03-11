import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/analytics_entity.dart';

abstract class AnalyticsRepository {
  Future<Either<Failure, AnalyticsEntity>> getEventAnalytics(int eventId);
}
