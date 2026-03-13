import 'package:equatable/equatable.dart';

abstract class OrganizerEvent extends Equatable {
  const OrganizerEvent();

  @override
  List<Object> get props => [];
}

class FetchOrganizerEvents extends OrganizerEvent {
  final int page;
  final int size;

  const FetchOrganizerEvents({this.page = 0, this.size = 10});

  @override
  List<Object> get props => [page, size];
}

class DeleteEventRequested extends OrganizerEvent {
  final int eventId;

  const DeleteEventRequested(this.eventId);

  @override
  List<Object> get props => [eventId];
}

class PublishEventRequested extends OrganizerEvent {
  final int eventId;

  const PublishEventRequested(this.eventId);

  @override
  List<Object> get props => [eventId];
}

class CancelEventRequested extends OrganizerEvent {
  final int eventId;
  final int organizerId;

  const CancelEventRequested(this.eventId, this.organizerId);

  @override
  List<Object> get props => [eventId, organizerId];
}
