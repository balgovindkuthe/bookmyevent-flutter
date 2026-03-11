import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/booking_entity.dart';
import '../repositories/booking_repository.dart';

class GetMyBookingsUseCase implements UseCase<List<BookingEntity>, NoParams> {
  final BookingRepository repository;

  GetMyBookingsUseCase(this.repository);

  @override
  Future<Either<Failure, List<BookingEntity>>> call(NoParams params) async {
    return await repository.getMyBookings();
  }
}
