import 'package:equatable/equatable.dart';

class CheckInEntity extends Equatable {
  final String status;
  final String message;
  final int ticketId;
  final String customerName;
  final DateTime scannedAt;

  const CheckInEntity({
    required this.status,
    required this.message,
    required this.ticketId,
    required this.customerName,
    required this.scannedAt,
  });

  @override
  List<Object?> get props => [status, message, ticketId, customerName, scannedAt];
}
