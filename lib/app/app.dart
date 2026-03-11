import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../di/service_locator.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/auth/presentation/bloc/auth_event.dart';
import '../features/auth/presentation/bloc/auth_state.dart';
import '../features/events/presentation/bloc/event_list_bloc.dart';
import '../features/events/presentation/bloc/organizer_bloc.dart';
import '../features/bookings/presentation/bloc/booking_bloc.dart';
import 'routes.dart';

class BookMyEventApp extends StatefulWidget {
  const BookMyEventApp({super.key});

  @override
  State<BookMyEventApp> createState() => _BookMyEventAppState();
}

class _BookMyEventAppState extends State<BookMyEventApp> {
  late final AuthBloc _authBloc;

  @override
  void initState() {
    super.initState();
    _authBloc = sl<AuthBloc>();
    _authBloc.add(CheckAuthStatus()); // Attempt auto-login on startup
  }

  @override
  void dispose() {
    _authBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _authBloc),
        BlocProvider(create: (_) => sl<EventListBloc>()),
        BlocProvider(create: (_) => sl<OrganizerBloc>()),
        BlocProvider(create: (_) => sl<BookingBloc>()),
      ],
      child: BlocListener<AuthBloc, AuthState>(
        bloc: _authBloc,
        listener: (context, state) {
          if (state is Authenticated) {
            if (state.user.role == 'ORGANIZER') {
              appRouter.go('/organizer');
            } else {
              appRouter.go('/home');
            }
          } else if (state is Unauthenticated) {
            appRouter.go('/login');
          }
        },
        child: MaterialApp.router(
          title: 'BookMyEvent',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          routerConfig: appRouter,
        ),
      ),
    );
  }
}
