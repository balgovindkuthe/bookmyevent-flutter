import 'package:equatable/equatable.dart';
import '../../domain/entities/event_entity.dart';
import '../../domain/entities/ticket_tier_entity.dart';

abstract class EventDetailState extends Equatable {
  const EventDetailState();

  @override
  List<Object?> get props => [];
}

class EventDetailInitial extends EventDetailState {}

class EventDetailLoading extends EventDetailState {}

class EventDetailLoaded extends EventDetailState {
  final EventEntity event;
  final List<TicketTierEntity> tiers;

  const EventDetailLoaded({required this.event, required this.tiers});

  @override
  List<Object?> get props => [event, tiers];
}

class EventDetailError extends EventDetailState {
  final String message;

  const EventDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
