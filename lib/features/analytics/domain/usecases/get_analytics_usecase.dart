import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/analytics_entity.dart';
import '../repositories/analytics_repository.dart';
import 'package:equatable/equatable.dart';

class GetEventAnalyticsUseCase implements UseCase<AnalyticsEntity, EventIdParams> {
  final AnalyticsRepository repository;

  GetEventAnalyticsUseCase(this.repository);

  @override
  Future<Either<Failure, AnalyticsEntity>> call(EventIdParams params) async {
    return await repository.getEventAnalytics(params.eventId);
  }
}

class EventIdParams extends Equatable {
  final int eventId;

  const EventIdParams({required this.eventId});

  @override
  List<Object> get props => [eventId];
}
