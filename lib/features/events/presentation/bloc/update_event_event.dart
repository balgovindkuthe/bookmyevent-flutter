import 'package:equatable/equatable.dart';

abstract class UpdateEventEvent extends Equatable {
  const UpdateEventEvent();

  @override
  List<Object?> get props => [];
}

class SubmitEventUpdate extends UpdateEventEvent {
  final int eventId;
  final String title;
  final String description;
  final String location;
  final DateTime date;
  final int capacity;

  const SubmitEventUpdate({
    required this.eventId,
    required this.title,
    required this.description,
    required this.location,
    required this.date,
    required this.capacity,
  });

  @override
  List<Object?> get props => [eventId, title, description, location, date, capacity];
}
