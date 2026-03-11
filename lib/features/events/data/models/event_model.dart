import '../../domain/entities/event_entity.dart';

class EventModel extends EventEntity {
  const EventModel({
    required super.id,
    required super.organizerId,
    required super.title,
    required super.description,
    required super.location,
    required super.eventDate,
    required super.capacity,
    required super.status,
    required super.createdAt,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'],
      organizerId: json['organizerId'],
      title: json['title'],
      description: json['description'],
      location: json['location'],
      eventDate: DateTime.parse(json['eventDate'] ?? DateTime.now().toIso8601String()),
      capacity: json['capacity'],
      status: json['status'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'organizerId': organizerId,
      'title': title,
      'description': description,
      'location': location,
      'eventDate': eventDate.toIso8601String(),
      'capacity': capacity,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
