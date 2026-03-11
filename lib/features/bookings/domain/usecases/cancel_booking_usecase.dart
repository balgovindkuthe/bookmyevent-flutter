import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/booking_repository.dart';
import 'get_booking_by_id_usecase.dart'; // Reusing BookingIdParams

class CancelBookingUseCase implements UseCase<void, BookingIdParams> {
  final BookingRepository repository;

  CancelBookingUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(BookingIdParams params) async {
    return await repository.cancelBooking(params.bookingId);
  }
}
