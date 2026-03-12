import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/event_entity.dart';
import '../repositories/event_repository.dart';

class PublishEventUseCase implements UseCase<EventEntity, PublishEventParams> {
  final EventRepository repository;

  PublishEventUseCase(this.repository);

  @override
  Future<Either<Failure, EventEntity>> call(PublishEventParams params) async {
    return await repository.publishEvent(params.eventId, params.organizerId);
  }
}

class PublishEventParams extends Equatable {
  final int eventId;
  final int organizerId;

  const PublishEventParams({required this.eventId, required this.organizerId});

  @override
  List<Object> get props => [eventId, organizerId];
}
