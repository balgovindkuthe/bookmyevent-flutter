import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/event_entity.dart';
import '../repositories/event_repository.dart';
import 'package:equatable/equatable.dart';

class CreateEventUseCase implements UseCase<EventEntity, CreateEventParams> {
  final EventRepository repository;

  CreateEventUseCase(this.repository);

  @override
  Future<Either<Failure, EventEntity>> call(CreateEventParams params) async {
    return await repository.createEvent(
      params.organizerId,
      params.title,
      params.description,
      params.location,
      params.eventDate,
      params.capacity,
    );
  }
}

class CreateEventParams extends Equatable {
  final int organizerId;
  final String title;
  final String description;
  final String location;
  final DateTime eventDate;
  final int capacity;

  const CreateEventParams({
    required this.organizerId,
    required this.title,
    required this.description,
    required this.location,
    required this.eventDate,
    required this.capacity,
  });

  @override
  List<Object> get props => [organizerId, title, description, location, eventDate, capacity];
}
