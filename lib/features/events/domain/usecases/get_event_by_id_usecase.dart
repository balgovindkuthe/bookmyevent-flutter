import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/event_entity.dart';
import '../repositories/event_repository.dart';
import 'package:equatable/equatable.dart';

class GetEventByIdUseCase implements UseCase<EventEntity, EventIdParams> {
  final EventRepository repository;

  GetEventByIdUseCase(this.repository);

  @override
  Future<Either<Failure, EventEntity>> call(EventIdParams params) async {
    return await repository.getEventById(params.id);
  }
}

class EventIdParams extends Equatable {
  final int id;

  const EventIdParams({required this.id});

  @override
  List<Object> get props => [id];
}
