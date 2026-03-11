import 'package:equatable/equatable.dart';

class BookingEntity extends Equatable {
  final int id;
  final int userId;
  final int eventId;
  final double totalAmount;
  final String status;
  final DateTime createdAt;

  const BookingEntity({
    required this.id,
    required this.userId,
    required this.eventId,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, userId, eventId, totalAmount, status, createdAt];
}
