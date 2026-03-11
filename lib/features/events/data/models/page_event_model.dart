import '../../domain/entities/page_event_entity.dart';
import 'event_model.dart';

class PageEventModel extends PageEventEntity {
  const PageEventModel({
    required super.totalElements,
    required super.totalPages,
    required super.size,
    required List<EventModel> content,
    required super.number,
    required super.first,
    required super.last,
    required super.empty,
  }) : super(
          content: content,
        );

  factory PageEventModel.fromJson(Map<String, dynamic> json) {
    return PageEventModel(
      totalElements: json['totalElements'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      size: json['size'] ?? 0,
      content: (json['content'] as List<dynamic>?)
              ?.map((e) => EventModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      number: json['number'] ?? 0,
      first: json['first'] ?? true,
      last: json['last'] ?? true,
      empty: json['empty'] ?? true,
    );
  }
}
