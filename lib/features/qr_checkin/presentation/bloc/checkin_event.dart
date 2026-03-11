import 'package:equatable/equatable.dart';

abstract class CheckInEvent extends Equatable {
  const CheckInEvent();

  @override
  List<Object> get props => [];
}

class ScanQrCodeRequested extends CheckInEvent {
  final String qrCodeUuid;

  const ScanQrCodeRequested(this.qrCodeUuid);

  @override
  List<Object> get props => [qrCodeUuid];
}
