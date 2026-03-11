import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/checkin_entity.dart';
import '../repositories/checkin_repository.dart';
import 'package:equatable/equatable.dart';

class ScanQrCodeUseCase implements UseCase<CheckInEntity, QrCodeParams> {
  final CheckInRepository repository;

  ScanQrCodeUseCase(this.repository);

  @override
  Future<Either<Failure, CheckInEntity>> call(QrCodeParams params) async {
    return await repository.scanQrCode(params.qrCodeUuid);
  }
}

class QrCodeParams extends Equatable {
  final String qrCodeUuid;

  const QrCodeParams({required this.qrCodeUuid});

  @override
  List<Object> get props => [qrCodeUuid];
}
