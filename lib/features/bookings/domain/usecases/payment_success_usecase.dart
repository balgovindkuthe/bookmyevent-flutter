import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/booking_entity.dart';
import '../repositories/booking_repository.dart';
import 'package:equatable/equatable.dart';

class PaymentSuccessUseCase implements UseCase<BookingEntity, PaymentSuccessParams> {
  final BookingRepository repository;

  PaymentSuccessUseCase(this.repository);

  @override
  Future<Either<Failure, BookingEntity>> call(PaymentSuccessParams params) async {
    return await repository.markPaymentSuccess(params.bookingId, params.providerTxId);
  }
}

class PaymentSuccessParams extends Equatable {
  final int bookingId;
  final String providerTxId;

  const PaymentSuccessParams({required this.bookingId, required this.providerTxId});

  @override
  List<Object> get props => [bookingId, providerTxId];
}
