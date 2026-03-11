import '../../domain/entities/checkin_entity.dart';

class CheckInModel extends CheckInEntity {
  const CheckInModel({
    required super.status,
    required super.message,
    required super.ticketId,
    required super.customerName,
    required super.scannedAt,
  });

  factory CheckInModel.fromJson(Map<String, dynamic> json) {
    return CheckInModel(
      status: json['status'],
      message: json['message'] ?? '',
      ticketId: json['ticketId'] ?? 0,
      customerName: json['customerName'] ?? '',
      scannedAt: json['scannedAt'] != null ? DateTime.parse(json['scannedAt']) : DateTime.now(),
    );
  }
}
