import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/create_booking_usecase.dart';
import '../../domain/usecases/get_my_bookings_usecase.dart';
import '../../domain/usecases/payment_success_usecase.dart';
import '../../domain/usecases/cancel_booking_usecase.dart';
import '../../domain/usecases/get_booking_by_id_usecase.dart';
import '../../../../core/usecase/usecase.dart';
import 'booking_event.dart';
import 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final CreateBookingUseCase createBookingUseCase;
  final GetMyBookingsUseCase getMyBookingsUseCase;
  final PaymentSuccessUseCase paymentSuccessUseCase;
  final CancelBookingUseCase cancelBookingUseCase;

  BookingBloc({
    required this.createBookingUseCase,
    required this.getMyBookingsUseCase,
    required this.paymentSuccessUseCase,
    required this.cancelBookingUseCase,
  }) : super(BookingInitial()) {
    on<CreateBookingRequested>(_onCreateBookingRequested);
    on<FetchMyBookings>(_onFetchMyBookings);
    on<CancelBookingRequested>(_onCancelBookingRequested);
  }

  Future<void> _onCreateBookingRequested(CreateBookingRequested event, Emitter<BookingState> emit) async {
    emit(BookingLoading());
    // 1. Create pending booking
    final createResult = await createBookingUseCase(
      CreateBookingParams(eventId: event.eventId, ticketTierId: event.ticketTierId, quantity: event.quantity),
    );

    await createResult.fold(
      (failure) async => emit(BookingError(failure.message)),
      (booking) async {
        // 2. Simulate payment processing locally
        // In a real app, this would integrate Stripe, Razorpay, etc.
        await Future.delayed(const Duration(seconds: 2));

        // 3. Confirm booking by hitting payment success webhook simulation
        final paymentResult = await paymentSuccessUseCase(
          PaymentSuccessParams(bookingId: booking.id, providerTxId: 'TXN_SIMULATED_${DateTime.now().millisecondsSinceEpoch}'),
        );

        paymentResult.fold(
          (failure) => emit(BookingError(failure.message)),
          (confirmedBooking) => emit(BookingSuccess(confirmedBooking)),
        );
      },
    );
  }

  Future<void> _onFetchMyBookings(FetchMyBookings event, Emitter<BookingState> emit) async {
    emit(BookingLoading());
    final result = await getMyBookingsUseCase(NoParams());
    result.fold(
      (failure) => emit(BookingError(failure.message)),
      (bookings) => emit(MyBookingsLoaded(bookings)),
    );
  }

  Future<void> _onCancelBookingRequested(CancelBookingRequested event, Emitter<BookingState> emit) async {
    emit(BookingLoading());
    final result = await cancelBookingUseCase(BookingIdParams(bookingId: event.bookingId));
    result.fold(
      (failure) => emit(BookingError(failure.message)),
      (_) {
        // Option to refetch bookings or just emit a success state.
        emit(BookingCancelled());
        add(FetchMyBookings()); // Reload list securely
      },
    );
  }
}
