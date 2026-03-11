import 'package:equatable/equatable.dart';

abstract class AnalyticsEvent extends Equatable {
  const AnalyticsEvent();

  @override
  List<Object> get props => [];
}

class FetchEventAnalytics extends AnalyticsEvent {
  final int eventId;

  const FetchEventAnalytics(this.eventId);

  @override
  List<Object> get props => [eventId];
}
