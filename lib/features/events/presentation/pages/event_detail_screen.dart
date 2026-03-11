import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../bloc/event_detail_bloc.dart';
import '../bloc/event_detail_event.dart';
import '../bloc/event_detail_state.dart';
import '../../../../di/service_locator.dart';
import '../../domain/entities/ticket_tier_entity.dart';
import '../../../../core/utils/snackbar_util.dart';
import '../../../../features/bookings/presentation/bloc/booking_bloc.dart';
import '../../../../features/bookings/presentation/bloc/booking_event.dart';
import '../../../../features/bookings/presentation/bloc/booking_state.dart';

class EventDetailScreen extends StatefulWidget {
  final int eventId;

  const EventDetailScreen({super.key, required this.eventId});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  int _selectedQuantity = 1;
  TicketTierEntity? _selectedTier;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<EventDetailBloc>()..add(FetchEventDetail(widget.eventId)),
      child: BlocListener<BookingBloc, BookingState>(
        listener: (context, state) {
          if (state is BookingSuccess) {
            SnackbarUtil.showSuccess(context, 'Booking Confirmed! 🎉');
            context.go('/my-bookings');
          } else if (state is BookingError) {
            SnackbarUtil.showError(context, state.message);
          }
        },
        child: Scaffold(
          appBar: AppBar(title: const Text('Event Details')),
        body: BlocBuilder<EventDetailBloc, EventDetailState>(
          builder: (context, state) {
            if (state is EventDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is EventDetailError) {
              return Center(child: Text(state.message));
            } else if (state is EventDetailLoaded) {
              final event = state.event;
              final tiers = state.tiers;

              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(event.title, style: Theme.of(context).textTheme.headlineMedium),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.location_on, color: Colors.grey),
                              const SizedBox(width: 8),
                              Expanded(child: Text(event.location, style: const TextStyle(fontSize: 16))),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.date_range, color: Colors.grey),
                              const SizedBox(width: 8),
                              Text(DateFormat('MMM dd, yyyy - HH:mm').format(event.eventDate.toLocal()), style: const TextStyle(fontSize: 16)),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Text('Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text(event.description, style: const TextStyle(fontSize: 16)),
                          const SizedBox(height: 24),
                          const Text('Select Tickets', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          if (tiers.isEmpty) const Text('No tickets available currently.'),
                          ...tiers.map((tier) {
                            final isSelected = _selectedTier?.id == tier.id;
                            return Card(
                              color: isSelected ? Colors.deepPurple.shade50 : null,
                              child: ListTile(
                                title: Text(tier.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text('Available: ${tier.availableQty}'),
                                trailing: Text('\$${tier.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                onTap: () {
                                  setState(() {
                                    _selectedTier = tier;
                                    _selectedQuantity = 1; // reset quantity on tier change
                                  });
                                },
                              ),
                            );
                          }),
                          if (_selectedTier != null) ...[
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Quantity:', style: TextStyle(fontSize: 16)),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove_circle_outline),
                                      onPressed: _selectedQuantity > 1 ? () => setState(() => _selectedQuantity--) : null,
                                    ),
                                    Text('$_selectedQuantity', style: const TextStyle(fontSize: 18)),
                                    IconButton(
                                      icon: const Icon(Icons.add_circle_outline),
                                      onPressed: _selectedQuantity < _selectedTier!.availableQty ? () => setState(() => _selectedQuantity++) : null,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  _buildBottomBar(context),
                ],
              );
            }
            return const SizedBox();
          },
        ),
      ),
    ),
  );
}

  Widget _buildBottomBar(BuildContext context) {
    if (_selectedTier == null) return const SizedBox();

    final total = _selectedTier!.price * _selectedQuantity;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.grey.withAlpha(50), blurRadius: 10, offset: const Offset(0, -5)),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Total Price', style: TextStyle(color: Colors.grey)),
                Text('\$${total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                if (_selectedTier != null) {
                  context.read<BookingBloc>().add(
                    CreateBookingRequested(
                      eventId: widget.eventId,
                      ticketTierId: _selectedTier!.id,
                      quantity: _selectedQuantity,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
              ),
              child: const Text('Book Now', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
