import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/event_entity.dart';
import '../bloc/organizer_bloc.dart';
import '../bloc/organizer_event.dart';
import '../bloc/organizer_state.dart';
import '../../../../di/service_locator.dart';
import '../../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../../features/auth/presentation/bloc/auth_event.dart';

class OrganizerDashboardScreen extends StatefulWidget {
  const OrganizerDashboardScreen({super.key});

  @override
  State<OrganizerDashboardScreen> createState() => _OrganizerDashboardScreenState();
}

class _OrganizerDashboardScreenState extends State<OrganizerDashboardScreen> {
  final _scrollController = ScrollController();
  late OrganizerBloc _organizerBloc;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _organizerBloc = sl<OrganizerBloc>();
    _organizerBloc.add(FetchOrganizerEvents(page: _currentPage, size: 10));
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _organizerBloc.close();
    super.dispose();
  }

  void _onScroll() {
    final state = _organizerBloc.state;
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      if (state is OrganizerLoaded && !state.hasReachedMax) {
        _currentPage++;
        _organizerBloc.add(FetchOrganizerEvents(page: _currentPage, size: 10));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _organizerBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Organizer Dashboard'),
          actions: [
            IconButton(
              icon: const Icon(Icons.qr_code_scanner),
              tooltip: 'Scan QR',
              onPressed: () => context.push('/scanner'),
            ),
            IconButton(
              icon: const Icon(Icons.bar_chart),
              tooltip: 'Analytics',
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                context.read<AuthBloc>().add(LogoutRequested());
              },
            ),
          ],
        ),
        body: BlocConsumer<OrganizerBloc, OrganizerState>(
          listener: (context, state) {
            if (state is EventDeletedSuccess) {
              _currentPage = 0;
              _organizerBloc.add(const FetchOrganizerEvents(page: 0, size: 10));
            }
          },
          builder: (context, state) {
            if (state is OrganizerInitial || (state is OrganizerLoading && _currentPage == 0)) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is OrganizerError) {
              return Center(child: Text(state.message));
            } else if (state is OrganizerLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  _currentPage = 0;
                  _organizerBloc.add(const FetchOrganizerEvents(page: 0, size: 10));
                },
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: state.events.length + (state.hasReachedMax ? 0 : 1),
                  itemBuilder: (context, index) {
                    if (index >= state.events.length) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    return _buildManageEventCard(context, state.events[index]);
                  },
                ),
              );
            }
            return const Center(child: Text('No events yet.\nTap + to create one.', textAlign: TextAlign.center));
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => context.push('/create-event'),
          icon: const Icon(Icons.add),
          label: const Text('Create Event'),
        ),
      ),
    );
  }

  Widget _buildManageEventCard(BuildContext context, EventEntity event) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      event.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'tiers') {
                        context.push('/manage-tiers/${event.id}');
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 'edit', child: Text('Edit Event')),
                      const PopupMenuItem(value: 'tiers', child: Text('Manage Ticket Tiers')),
                      const PopupMenuItem(
                          value: 'delete',
                          child: Text('Delete Event', style: TextStyle(color: Colors.red))),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(DateFormat('MMM dd, yyyy').format(event.eventDate.toLocal()),
                      style: const TextStyle(color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Chip(
                    label: Text(event.status),
                    backgroundColor:
                        event.status == 'PUBLISHED' ? Colors.green.shade100 : Colors.orange.shade100,
                  ),
                  TextButton(onPressed: () {}, child: const Text('View Analytics')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
