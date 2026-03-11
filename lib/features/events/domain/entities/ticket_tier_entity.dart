import 'package:equatable/equatable.dart';

class TicketTierEntity extends Equatable {
  final int id;
  final int eventId;
  final String name;
  final double price;
  final int capacity;
  final int availableQty;

  const TicketTierEntity({
    required this.id,
    required this.eventId,
    required this.name,
    required this.price,
    required this.capacity,
    required this.availableQty,
  });

  @override
  List<Object?> get props => [id, eventId, name, price, capacity, availableQty];
}
