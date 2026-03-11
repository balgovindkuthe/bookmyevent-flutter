import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../datasources/booking_remote_datasource.dart';
import '../../domain/entities/booking_entity.dart';
import '../../domain/repositories/booking_repository.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource remoteDataSource;

  BookingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, BookingEntity>> createBooking(int eventId, int ticketTierId, int quantity) async {
    try {
      final booking = await remoteDataSource.createBooking(eventId, ticketTierId, quantity);
      return Right(booking);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, BookingEntity>> getBookingById(int bookingId) async {
    try {
      final booking = await remoteDataSource.getBookingById(bookingId);
      return Right(booking);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<BookingEntity>>> getMyBookings() async {
    try {
      final bookings = await remoteDataSource.getMyBookings();
      return Right(bookings);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, BookingEntity>> markPaymentSuccess(int bookingId, String providerTxId) async {
    try {
      final booking = await remoteDataSource.markPaymentSuccess(bookingId, providerTxId);
      return Right(booking);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> cancelBooking(int bookingId) async {
    try {
      await remoteDataSource.cancelBooking(bookingId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
