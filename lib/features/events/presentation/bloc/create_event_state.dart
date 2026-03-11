import 'package:equatable/equatable.dart';
import '../../domain/entities/event_entity.dart';

abstract class CreateEventState extends Equatable {
  const CreateEventState();

  @override
  List<Object?> get props => [];
}

class CreateEventInitial extends CreateEventState {}

class CreateEventLoading extends CreateEventState {}

class CreateEventSuccess extends CreateEventState {
  final EventEntity event;

  const CreateEventSuccess(this.event);

  @override
  List<Object?> get props => [event];
}

class CreateEventError extends CreateEventState {
  final String message;

  const CreateEventError(this.message);

  @override
  List<Object?> get props => [message];
}
