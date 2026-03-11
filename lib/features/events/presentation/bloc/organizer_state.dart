import 'package:equatable/equatable.dart';
import '../../domain/entities/event_entity.dart';

abstract class OrganizerState extends Equatable {
  const OrganizerState();

  @override
  List<Object?> get props => [];
}

class OrganizerInitial extends OrganizerState {}

class OrganizerLoading extends OrganizerState {}

class OrganizerLoaded extends OrganizerState {
  final List<EventEntity> events;
  final bool hasReachedMax;

  const OrganizerLoaded({required this.events, required this.hasReachedMax});

  @override
  List<Object?> get props => [events, hasReachedMax];
}

class OrganizerError extends OrganizerState {
  final String message;

  const OrganizerError(this.message);

  @override
  List<Object?> get props => [message];
}

class EventDeletedSuccess extends OrganizerState {}
