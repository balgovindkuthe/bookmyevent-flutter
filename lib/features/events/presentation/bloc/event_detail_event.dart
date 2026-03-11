import 'package:equatable/equatable.dart';

abstract class EventDetailEvent extends Equatable {
  const EventDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchEventDetail extends EventDetailEvent {
  final int eventId;

  const FetchEventDetail(this.eventId);

  @override
  List<Object> get props => [eventId];
}
