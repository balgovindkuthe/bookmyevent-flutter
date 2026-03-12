import 'package:equatable/equatable.dart';
import '../../domain/entities/event_entity.dart';

abstract class UpdateEventState extends Equatable {
  const UpdateEventState();
  
  @override
  List<Object?> get props => [];
}

class UpdateEventInitial extends UpdateEventState {}

class UpdateEventLoading extends UpdateEventState {}

class UpdateEventSuccess extends UpdateEventState {
  final EventEntity event;

  const UpdateEventSuccess(this.event);

  @override
  List<Object?> get props => [event];
}

class UpdateEventError extends UpdateEventState {
  final String message;

  const UpdateEventError(this.message);

  @override
  List<Object?> get props => [message];
}
