import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/booking_entity.dart';

abstract class BookingRepository {
  Future<Either<Failure, BookingEntity>> createBooking(int eventId, int ticketTierId, int quantity);
  Future<Either<Failure, BookingEntity>> getBookingById(int bookingId);
  Future<Either<Failure, List<BookingEntity>>> getMyBookings();
  Future<Either<Failure, BookingEntity>> markPaymentSuccess(int bookingId, String providerTxId);
  Future<Either<Failure, void>> cancelBooking(int bookingId);
}
