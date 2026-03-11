import 'package:equatable/equatable.dart';
import '../../domain/entities/event_entity.dart';

abstract class EventListState extends Equatable {
  const EventListState();

  @override
  List<Object> get props => [];
}

class EventListInitial extends EventListState {}

class EventListLoading extends EventListState {}

class EventListLoaded extends EventListState {
  final List<EventEntity> events;
  final bool hasReachedMax;

  const EventListLoaded({required this.events, required this.hasReachedMax});

  @override
  List<Object> get props => [events, hasReachedMax];
}

class EventListError extends EventListState {
  final String message;

  const EventListError(this.message);

  @override
  List<Object> get props => [message];
}
