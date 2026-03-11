import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/booking_entity.dart';
import '../repositories/booking_repository.dart';
import 'package:equatable/equatable.dart';

class GetBookingByIdUseCase implements UseCase<BookingEntity, BookingIdParams> {
  final BookingRepository repository;

  GetBookingByIdUseCase(this.repository);

  @override
  Future<Either<Failure, BookingEntity>> call(BookingIdParams params) async {
    return await repository.getBookingById(params.bookingId);
  }
}

class BookingIdParams extends Equatable {
  final int bookingId;

  const BookingIdParams({required this.bookingId});

  @override
  List<Object> get props => [bookingId];
}
