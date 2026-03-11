import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/event_entity.dart';
import '../bloc/event_list_bloc.dart';
import '../bloc/event_list_event.dart';
import '../bloc/event_list_state.dart';
import '../../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../../features/auth/presentation/bloc/auth_event.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollController = ScrollController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    context.read<EventListBloc>().add(FetchEvents(page: _currentPage, size: 10));
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final state = context.read<EventListBloc>().state;
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      if (state is EventListLoaded && !state.hasReachedMax) {
        _currentPage++;
        context.read<EventListBloc>().add(FetchEvents(page: _currentPage, size: 10));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover Events'),
        actions: [
          IconButton(
            icon: const Icon(Icons.confirmation_number),
            tooltip: 'My Tickets',
            onPressed: () => context.push('/my-bookings'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => context.read<AuthBloc>().add(LogoutRequested()),
          ),
        ],
      ),
      body: BlocBuilder<EventListBloc, EventListState>(
        builder: (context, state) {
          if (state is EventListInitial || (state is EventListLoading && _currentPage == 0)) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is EventListError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      _currentPage = 0;
                      context.read<EventListBloc>().add(RefreshEvents());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (state is EventListLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                _currentPage = 0;
                context.read<EventListBloc>().add(RefreshEvents());
              },
              child: ListView.builder(
                controller: _scrollController,
                itemCount: state.events.length + (state.hasReachedMax ? 0 : 1),
                itemBuilder: (context, index) {
                  if (index >= state.events.length) {
                    return const Center(
                        child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ));
                  }
                  return EventCard(event: state.events[index]);
                },
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final EventEntity event;

  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.push('/event/${event.id}'),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                event.title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(event.location, style: const TextStyle(color: Colors.grey)),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat('MMM dd, yyyy - hh:mm a').format(event.eventDate.toLocal()),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Chip(
                    label: Text(event.status),
                    backgroundColor: event.status == 'PUBLISHED'
                        ? Colors.green.shade100
                        : Colors.orange.shade100,
                  ),
                  Text(
                    'Capacity: ${event.capacity}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
