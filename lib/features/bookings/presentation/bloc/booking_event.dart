import 'package:equatable/equatable.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object> get props => [];
}

class CreateBookingRequested extends BookingEvent {
  final int eventId;
  final int ticketTierId;
  final int quantity;

  const CreateBookingRequested({
    required this.eventId,
    required this.ticketTierId,
    required this.quantity,
  });

  @override
  List<Object> get props => [eventId, ticketTierId, quantity];
}

class FetchMyBookings extends BookingEvent {}

class CancelBookingRequested extends BookingEvent {
  final int bookingId;

  const CancelBookingRequested(this.bookingId);

  @override
  List<Object> get props => [bookingId];
}
