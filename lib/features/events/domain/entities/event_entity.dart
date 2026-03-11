import 'package:equatable/equatable.dart';

class EventEntity extends Equatable {
  final int id;
  final int organizerId;
  final String title;
  final String description;
  final String location;
  final DateTime eventDate;
  final int capacity;
  final String status;
  final DateTime createdAt;

  const EventEntity({
    required this.id,
    required this.organizerId,
    required this.title,
    required this.description,
    required this.location,
    required this.eventDate,
    required this.capacity,
    required this.status,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        organizerId,
        title,
        description,
        location,
        eventDate,
        capacity,
        status,
        createdAt,
      ];
}
