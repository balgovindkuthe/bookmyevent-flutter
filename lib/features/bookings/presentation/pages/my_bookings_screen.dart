import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:intl/intl.dart';
import '../bloc/booking_bloc.dart';
import '../bloc/booking_event.dart';
import '../bloc/booking_state.dart';
import '../../domain/entities/booking_entity.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BookingBloc>().add(FetchMyBookings());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Tickets/Bookings')),
      body: BlocBuilder<BookingBloc, BookingState>(
        builder: (context, state) {
          if (state is BookingLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BookingError) {
            return Center(child: Text(state.message));
          } else if (state is MyBookingsLoaded) {
            final bookings = state.bookings;
            if (bookings.isEmpty) {
              return const Center(child: Text('No bookings found.'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                return BookingCard(booking: booking);
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

class BookingCard extends StatelessWidget {
  final BookingEntity booking;

  const BookingCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: booking.status == 'CONFIRMED' ? Colors.green.shade50 : Colors.red.shade50,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Booking #${booking.id}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Chip(
                  label: Text(booking.status, style: const TextStyle(fontSize: 12)),
                  backgroundColor: booking.status == 'CONFIRMED' ? Colors.green.shade200 : Colors.red.shade200,
                  padding: EdgeInsets.zero,
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (booking.status == 'CONFIRMED')
                  Container(
                    width: 100,
                    height: 100,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300)),
                    child: QrImageView(
                      data: 'TICKET_${booking.id}_QR', // Assuming unique ticket ID format or get from backend
                      version: QrVersions.auto,
                    ),
                  ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Amount Paid: \$${booking.totalAmount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text('Date: ${DateFormat('MMM dd, yyyy HH:mm').format(booking.createdAt.toLocal())}', style: const TextStyle(color: Colors.grey)),
                      const SizedBox(height: 16),
                      if (booking.status != 'CANCELLED')
                        TextButton.icon(
                          onPressed: () {
                             _showCancelDialog(context, booking.id);
                          },
                          icon: const Icon(Icons.cancel, color: Colors.red),
                          label: const Text('Cancel Booking', style: TextStyle(color: Colors.red)),
                        )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showCancelDialog(BuildContext context, int id) {
     showDialog(
       context: context, 
       builder: (ctx) => AlertDialog(
          title: const Text('Cancel Booking'),
          content: const Text('Are you sure you want to cancel this ticket?'),
          actions: [
             TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('No')),
             TextButton(
               onPressed: () {
                  Navigator.pop(ctx);
                  context.read<BookingBloc>().add(CancelBookingRequested(id));
               }, 
               child: const Text('Yes, Cancel', style: TextStyle(color: Colors.red))
             ),
          ],
       )
     );
  }
}
