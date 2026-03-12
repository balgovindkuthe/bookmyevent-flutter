import 'package:equatable/equatable.dart';

abstract class CreateEventEvent extends Equatable {
  const CreateEventEvent();

  @override
  List<Object> get props => [];
}

class SubmitEventCreation extends CreateEventEvent {
  final int organizerId; // Added this field
  final String title;
  final String description;
  final String location;
  final DateTime date;
  final int capacity;

  const SubmitEventCreation({
    required this.organizerId,
    required this.title,
    required this.description,
    required this.location,
    required this.date,
    required this.capacity,
  });

  @override
  List<Object> get props => [organizerId, title, description, location, date, capacity];
}