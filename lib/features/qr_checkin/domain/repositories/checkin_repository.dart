import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/checkin_entity.dart';

abstract class CheckInRepository {
  Future<Either<Failure, CheckInEntity>> scanQrCode(String qrCodeUuid);
}
