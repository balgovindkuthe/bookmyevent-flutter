import 'package:equatable/equatable.dart';

abstract class EventListEvent extends Equatable {
  const EventListEvent();

  @override
  List<Object> get props => [];
}

class FetchEvents extends EventListEvent {
  final int page;
  final int size;

  const FetchEvents({this.page = 0, this.size = 10});

  @override
  List<Object> get props => [page, size];
}

class RefreshEvents extends EventListEvent {}
