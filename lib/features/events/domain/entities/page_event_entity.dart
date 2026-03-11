import 'package:equatable/equatable.dart';
import 'event_entity.dart';

class PageEventEntity extends Equatable {
  final int totalElements;
  final int totalPages;
  final int size;
  final List<EventEntity> content;
  final int number;
  final bool first;
  final bool last;
  final bool empty;

  const PageEventEntity({
    required this.totalElements,
    required this.totalPages,
    required this.size,
    required this.content,
    required this.number,
    required this.first,
    required this.last,
    required this.empty,
  });

  @override
  List<Object?> get props => [
        totalElements,
        totalPages,
        size,
        content,
        number,
        first,
        last,
        empty,
      ];
}
