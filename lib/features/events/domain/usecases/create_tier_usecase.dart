import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/ticket_tier_entity.dart';
import '../repositories/event_repository.dart';
import 'package:equatable/equatable.dart';

class CreateTicketTierUseCase implements UseCase<TicketTierEntity, CreateTierParams> {
  final EventRepository repository;

  CreateTicketTierUseCase(this.repository);

  @override
  Future<Either<Failure, TicketTierEntity>> call(CreateTierParams params) async {
    return await repository.createTicketTier(params.eventId, params.name, params.price, params.capacity);
  }
}

class CreateTierParams extends Equatable {
  final int eventId;
  final String name;
  final double price;
  final int capacity;

  const CreateTierParams({
    required this.eventId,
    required this.name,
    required this.price,
    required this.capacity,
  });

  @override
  List<Object> get props => [eventId, name, price, capacity];
}
