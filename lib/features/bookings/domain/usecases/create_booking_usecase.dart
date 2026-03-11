import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/booking_entity.dart';
import '../repositories/booking_repository.dart';
import 'package:equatable/equatable.dart';

class CreateBookingUseCase implements UseCase<BookingEntity, CreateBookingParams> {
  final BookingRepository repository;

  CreateBookingUseCase(this.repository);

  @override
  Future<Either<Failure, BookingEntity>> call(CreateBookingParams params) async {
    return await repository.createBooking(params.eventId, params.ticketTierId, params.quantity);
  }
}

class CreateBookingParams extends Equatable {
  final int eventId;
  final int ticketTierId;
  final int quantity;

  const CreateBookingParams({
    required this.eventId,
    required this.ticketTierId,
    required this.quantity,
  });

  @override
  List<Object> get props => [eventId, ticketTierId, quantity];
}
