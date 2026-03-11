import 'package:equatable/equatable.dart';

class AnalyticsEntity extends Equatable {
  final int eventId;
  final String eventTitle;
  final double totalRevenue;
  final int totalCheckIns;
  final Map<String, int> ticketsSoldPerTier;

  const AnalyticsEntity({
    required this.eventId,
    required this.eventTitle,
    required this.totalRevenue,
    required this.totalCheckIns,
    required this.ticketsSoldPerTier,
  });

  @override
  List<Object?> get props => [eventId, eventTitle, totalRevenue, totalCheckIns, ticketsSoldPerTier];
}
