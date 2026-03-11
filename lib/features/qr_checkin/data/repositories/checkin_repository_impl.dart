import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../datasources/checkin_remote_datasource.dart';
import '../../domain/entities/checkin_entity.dart';
import '../../domain/repositories/checkin_repository.dart';

class CheckInRepositoryImpl implements CheckInRepository {
  final CheckInRemoteDataSource remoteDataSource;

  CheckInRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, CheckInEntity>> scanQrCode(String qrCodeUuid) async {
    try {
      final checkin = await remoteDataSource.handleScan(qrCodeUuid);
      return Right(checkin);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
