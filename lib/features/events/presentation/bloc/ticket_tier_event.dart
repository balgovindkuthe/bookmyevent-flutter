import 'package:equatable/equatable.dart';

abstract class TicketTierEvent extends Equatable {
  const TicketTierEvent();

  @override
  List<Object> get props => [];
}

class FetchTicketTiers extends TicketTierEvent {
  final int eventId;

  const FetchTicketTiers(this.eventId);

  @override
  List<Object> get props => [eventId];
}

class CreateTicketTierRequested extends TicketTierEvent {
  final int eventId;
  final String name;
  final double price;
  final int capacity;

  const CreateTicketTierRequested({
    required this.eventId,
    required this.name,
    required this.price,
    required this.capacity,
  });

  @override
  List<Object> get props => [eventId, name, price, capacity];
}
