import '../../domain/entities/ticket_tier_entity.dart';

class TicketTierModel extends TicketTierEntity {
  const TicketTierModel({
    required super.id,
    required super.eventId,
    required super.name,
    required super.price,
    required super.capacity,
    required super.availableQty,
  });

  factory TicketTierModel.fromJson(Map<String, dynamic> json) {
    return TicketTierModel(
      id: json['id'],
      eventId: json['eventId'],
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      capacity: json['capacity'],
      availableQty: json['availableQty'],
    );
  }
}
