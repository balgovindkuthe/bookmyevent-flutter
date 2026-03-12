import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/event_entity.dart';
import '../repositories/event_repository.dart';

class UpdateEventUseCase implements UseCase<EventEntity, UpdateEventParams> {
  final EventRepository repository;

  UpdateEventUseCase(this.repository);

  @override
  Future<Either<Failure, EventEntity>> call(UpdateEventParams params) async {
    return await repository.updateEvent(
      params.eventId,
      params.title,
      params.description,
      params.location,
      params.eventDate,
      params.capacity,
    );
  }
}

class UpdateEventParams extends Equatable {
  final int eventId;
  final String title;
  final String description;
  final String location;
  final DateTime eventDate;
  final int capacity;

  const UpdateEventParams({
    required this.eventId,
    required this.title,
    required this.description,
    required this.location,
    required this.eventDate,
    required this.capacity,
  });

  @override
  List<Object> get props => [eventId, title, description, location, eventDate, capacity];
}
