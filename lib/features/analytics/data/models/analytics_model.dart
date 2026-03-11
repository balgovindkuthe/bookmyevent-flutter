import '../../domain/entities/analytics_entity.dart';

class AnalyticsModel extends AnalyticsEntity {
  const AnalyticsModel({
    required super.eventId,
    required super.eventTitle,
    required super.totalRevenue,
    required super.totalCheckIns,
    required super.ticketsSoldPerTier,
  });

  factory AnalyticsModel.fromJson(Map<String, dynamic> json) {
    return AnalyticsModel(
      eventId: json['eventId'],
      eventTitle: json['eventTitle'] ?? '',
      totalRevenue: (json['totalRevenue'] as num?)?.toDouble() ?? 0.0,
      totalCheckIns: json['totalCheckIns'] ?? 0,
      ticketsSoldPerTier: (json['ticketsSoldPerTier'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, value as int),
          ) ??
          {},
    );
  }
}
