import 'package:equatable/equatable.dart';
import '../../domain/entities/booking_entity.dart';

abstract class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object?> get props => [];
}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingSuccess extends BookingState {
  final BookingEntity booking;

  const BookingSuccess(this.booking);

  @override
  List<Object?> get props => [booking];
}

class MyBookingsLoaded extends BookingState {
  final List<BookingEntity> bookings;

  const MyBookingsLoaded(this.bookings);

  @override
  List<Object?> get props => [bookings];
}

class BookingError extends BookingState {
  final String message;

  const BookingError(this.message);

  @override
  List<Object?> get props => [message];
}

class BookingCancelled extends BookingState {}
