import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/register_page.dart';
import '../features/events/presentation/pages/home_screen.dart';
import '../features/events/presentation/pages/event_detail_screen.dart';
import '../features/bookings/presentation/pages/my_bookings_screen.dart';
import '../features/events/presentation/pages/organizer_dashboard_screen.dart';
import '../features/events/presentation/pages/create_event_screen.dart';
import '../features/events/presentation/pages/manage_ticket_tiers_screen.dart';
import '../features/qr_checkin/presentation/pages/qr_scanner_screen.dart';
import '../features/analytics/presentation/pages/event_analytics_screen.dart';
import '../features/events/domain/entities/event_entity.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/event/:id',
      name: 'eventDetail',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return EventDetailScreen(eventId: id);
      },
    ),
    GoRoute(
      path: '/my-bookings',
      name: 'myBookings',
      builder: (context, state) => const MyBookingsScreen(),
    ),
    GoRoute(
      path: '/organizer',
      name: 'organizerDashboard',
      builder: (context, state) => const OrganizerDashboardScreen(),
    ),
    GoRoute(
      path: '/create-event',
      name: 'createEvent',
      builder: (context, state) {
        final event = state.extra as EventEntity?;
        return CreateEventScreen(event: event);
      },
    ),
    GoRoute(
      path: '/manage-tiers/:eventId',
      name: 'manageTiers',
      builder: (context, state) {
         final eventId = int.parse(state.pathParameters['eventId']!);
         return ManageTicketTiersScreen(eventId: eventId);
      },
    ),
    GoRoute(
      path: '/scanner',
      name: 'scanner',
      builder: (context, state) => const QrScannerScreen(),
    ),
    GoRoute(
      path: '/analytics/:eventId',
      name: 'eventAnalytics',
      builder: (context, state) {
         final eventId = int.parse(state.pathParameters['eventId']!);
         return EventAnalyticsScreen(eventId: eventId);
      },
    ),
  ],
);
