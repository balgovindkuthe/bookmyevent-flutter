import 'package:equatable/equatable.dart';
import '../../domain/entities/ticket_tier_entity.dart';

abstract class TicketTierState extends Equatable {
  const TicketTierState();

  @override
  List<Object?> get props => [];
}

class TicketTierInitial extends TicketTierState {}

class TicketTierLoading extends TicketTierState {}

class TicketTiersLoaded extends TicketTierState {
  final List<TicketTierEntity> tiers;

  const TicketTiersLoaded(this.tiers);

  @override
  List<Object?> get props => [tiers];
}

class TicketTierCreationSuccess extends TicketTierState {}

class TicketTierError extends TicketTierState {
  final String message;

  const TicketTierError(this.message);

  @override
  List<Object?> get props => [message];
}
